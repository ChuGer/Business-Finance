package businessfinance

import grails.converters.JSON
import domain.Operation
import domain.CategoryOp
import org.apache.commons.lang.StringUtils

class ReportController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "report",
          action: 'index'
  ]
  def index = {}

  def lineChart = {
    def lineChart = [
            [type: 'date', name: 'Data', data: [[2008, 1, 1], [2008, 2, 1], [2008, 3, 1]]],
            [type: 'number', name: 'Hours per Day', data: [11, 34, 465]],
            [type: 'number', name: 'Sales', data: [345, 3, 465]]
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
    if (session.catView ==null)
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