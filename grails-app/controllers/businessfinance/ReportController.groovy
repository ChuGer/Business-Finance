package businessfinance

import domain.CategoryOp
import domain.Operation
import grails.converters.JSON
import java.text.SimpleDateFormat
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class ReportController {
  static navigation = [
          group: 'tabs',
          order: 4,
          title: "report",
          action: 'index'
  ]

  // Export service provided by Export plugin
  def exportService
  def userService
  def fetchService
  def persistService

  def index = {
    userService.saveUserInfo(this.class.simpleName)
    if (!params.max) params.max = 10

    if (params?.format && params.format != "html") {
      response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
      response.setHeader("Content-disposition", "attachment; filename=books.${params.extension}")
      def fields = ["name", "startDate", "sum", "type", "bill"]
      def labels = [:]
      fields.each { f ->
        labels.put(f, getMessage(f))
      }
      exportService.export(params.format, response.outputStream, Operation.findAll(), fields, labels, [:], [:])
    }
    def treeData = fetchService.getPureCategoryOpTree()
    println treeData
    [treeData: treeData as JSON]

  }

  def treeCheck = {
    persistService.persistCheckEvent(params)
    render ('')
  }

  def getMessage(code) {
    g.message(code: 'operation.' + code + '.label')
  }

  def lineChart = {
    //dateMap contains startDate and map of two values by type 0 - outcome sum, 1 - income sum
    def dateMap = [:]
    Operation.findAll().each { o ->
      def key = o.type == 1 ? 'in' : 'out'
      def titleKey = o.type == 1 ? 'inT' : 'outT'
      def date = o.startDate
      def sum = o.sum
      def title = o.name

      if (dateMap.containsKey(date)) {
        def map = dateMap.get(date)
        if (map.containsKey(key)) {
          def oldSum = map.get(key)
          def oldTitle = map.get(titleKey)
          map.put(key, oldSum + sum)
          map.put(titleKey, oldTitle + ' ' + title)
        } else {
          map.put(key, sum)
          map.put(titleKey, title)
        }
        dateMap.put(date, map)
      } else {
        dateMap.put(date, [(key): sum, (titleKey): title])
      }
    }

    // creating 3 lists for JSON storage
    def dateList = []
    def outcomeList = []
    def outcomeTitleList = []
    def incomeList = []
    def incomeTitleList = []
    dateMap.each { o ->
      dateList.add(o.key)
      outcomeList.add(o.value.get('out'))
      outcomeTitleList.add(o.value.get('outT'))
      incomeList.add(o.value.get('in'))
      incomeTitleList.add(o.value.get('inT'))
    }

    def lineChart = [
            [type: 'date', name: 'Operation Date', data: dateList],
            [type: 'number', name: g.message(code: 'operation.type.outcome'), data: outcomeList],
            [type: 'string', name: 'outcomeTitle', data: outcomeTitleList],
            [type: 'number', name: g.message(code: 'operation.type.income'), data: incomeList],
            [type: 'string', name: 'incomeTitle', data: incomeTitleList],
    ];

    render lineChart as JSON
  }

  def pieChart = {
    def pieChart = session.pieChart ?:
      [
              data:
              [
                      cols: [[type: 'string'], [type: 'number']],
                      rows: [
                              [c: [[v: g.message(code: 'operation.type.outcome')], [v: getOpsSumByType(0)]]],
                              [c: [[v: g.message(code: 'operation.type.income')], [v: getOpsSumByType(1)]]]
                      ]

              ],
              title: g.message(code: 'operation.type.all'),
              colors: ['red', 'green']
      ]

    session.visibleCats = session.visibleCats ?: [1L, 1L]
    session.historyCats = session.historyCats ?: []
    render pieChart as JSON
  }

  def getOpsSumByType(type) {
    def opsSum = 0
    Operation.findAllByType(type).each {o -> opsSum += o.sum};
    opsSum
  }

  def updatePie = {
    // clicked row in pieChart
    def typeId = params.id.toInteger()
    // catView - type of operation (0 - outcome, 1 - income)
    if (session.catView == null)
      session.catView = typeId
    def clickedCatId = session.visibleCats.get(typeId)
    if ('undef'.equals(clickedCatId))
      redirect(action: up)
    else {
      recreatePieChart(clickedCatId)
      render session.pieChart as JSON
    }
  }

  def recursiveSum(CategoryOp cat, sum) {
    cat.operations.each { o ->
      if (o.type == session.catView)
        sum += o.sum
    }
    cat.categories.each { c ->
      sum += recursiveSum(c, 0)
    }
    sum
  }

  def up = {
    def list = session.historyCats
    if (list.size() > 1) {
      list.pop()
      recreatePieChart(list.pop())
      render('')
    } else {
      redirect(action: root)
    }
  }

  def root = {
    session.pieChart = null
    session.catView = null
    session.visibleCats = null
    session.historyCats = null
    render('')
  }

  def recreatePieChart(clickedCatId) {
    if (!clickedCatId.equals('undef')) {
      session.historyCats.add(clickedCatId)
      def clickedCat = CategoryOp.findById(clickedCatId)
      def dataMap = [:]
      session.visibleCats = []
      def colors = []

      clickedCat.operations.each {o ->
        if (o.type == session.catView) {
          session.visibleCats.add('undef')
          dataMap.put(o.name, o.sum)
          colors.add('gray')
        }
      }
      clickedCat.categories.each {c ->
        def sum = recursiveSum(c, 0)
        if (sum != 0) {
          session.visibleCats.add(c.id)
          dataMap.put(c.name, sum)
          colors.add(c.color)
        }
      }
      // fill dataTable for Google Chart Api
      def list = []
      dataMap.each {m ->
        list.add(['c': [['v': m.key], ['v': m.value]]])
      }
      // creating title
      def title = session.catView ? g.message(code: 'operation.type.income') : g.message(code: 'operation.type.outcome')
      def curCat = clickedCat
      def listCatNames = [curCat.name]
      while (curCat.category != null) {
        curCat = curCat.category
        listCatNames.add(curCat.name)
      }
      listCatNames = listCatNames.reverse()
      title += ' | ' + StringUtils.join(listCatNames, ' > ')

      // generating JSON chart data
      session.pieChart = [
              data: [
                      cols: [[type: 'string'], [type: 'number']],
                      rows: list
              ],
              title: title,
              colors: colors
      ]
    }
  }

  def changeDateRange = {
    def sdf = new SimpleDateFormat("M/d/yyyy")
    session.startDate = sdf.parse(params.startDate)
    session.endDate = sdf.parse(params.endDate)
    render('')
  }
}