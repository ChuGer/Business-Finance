package businessfinance

import grails.converters.JSON
import domain.Operation
import domain.CategoryOp
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class ReportController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "report",
          action: 'index'
  ]

  // Export service provided by Export plugin
  def exportService

  def index = {
    if (!params.max) params.max = 10

    if (params?.format && params.format != "html") {
      response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
      response.setHeader("Content-disposition", "attachment; filename=books.${params.extension}")
      def fields = ["name", "startDate","sum","type","bill"]
      def labels = [:]
      fields.each { f->
        labels.put(f, getMessage(f))
      }
      exportService.export(params.format, response.outputStream, Operation.findAll(), fields, labels, [:],[:])
    }
  }

  def getMessage(code){
     g.message(code: 'operation.'+code+'.label')
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
        println map
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

    println lineChart
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

    session.cat = session.cat ?: [0: 1, 1: 1]
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
    def clickedCatId = session.cat.get(typeId)
    recreatePieChart(clickedCatId)
    render session.pieChart as JSON
  }

  def recursiveSum(CategoryOp cat, sum) {
    cat.operations.each { o ->
      if (o.type == session.catView)
        sum += o.sum
    }
    cat.categories.each {c ->
      sum += recursiveSum(c, 0)
    }
    sum
  }

  def up = {
    def parentCatId = session.cat.get(0)
    def parentCat = CategoryOp.findById(parentCatId)
    if (parentCat.category != null) {
      recreatePieChart(parentCat.category.id)
      render session.pieChart as JSON
    } else {
      redirect(action: root)
    }
  }

  def root = {
    session.pieChart = null
    session.catView = null
    session.cat = null
    render('')
  }

  def recreatePieChart(clickedCatId) {
    if (!clickedCatId.equals('undef')) {
      def clickedCat = CategoryOp.findById(clickedCatId)
      def dataMap = [:]
      session.cat = [:]
      def colors = []

      def index = 0
      clickedCat.operations.each {o ->
        if (o.type == session.catView) {
          session.cat.put(index++, o.category.id)
          dataMap.put(o.name, o.sum)
          colors.add('gray')
        }
      }
      clickedCat.categories.each {c ->
        def sum = recursiveSum(c, 0)
        if (sum != 0) {
          session.cat.put(index++, c.id)
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
}