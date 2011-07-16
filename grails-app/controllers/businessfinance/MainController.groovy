package businessfinance

import domain.Bill
import domain.Operation
import grails.converters.JSON
import java.text.SimpleDateFormat

class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: 'Главная страница',
          action: 'index'
  ]
  def springSecurityService
  def categoryService

  def index = {
    if (springSecurityService.getCurrentUser())
    [treeData: categoryService.getCategoryTree() as JSON]
    else {  // goes as demonstration tree data?
      def treeData = [
              [data: 'ExCateg1', attr: [id: '23'], children: [[[data: 'Bill1', attr: [id: '26']],
                      [data: 'bill2', attr: [id: '11']]]]],
              [data: 'ExCateg2', attr: [id: '18'], children: [[[data: 'bill t', attr: [id: '29']], [data: 'Chagur', attr: [id: '34']]]]]
      ];
      [treeData: treeData as JSON]
    }
  }

  def treeCheck = {
    categoryService.persistCheckEvent(params)
    // TODO: select all persist problem
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]
    render tdata as JSON
  }

  def addEvent = {
    //TODO : something more simply?
    def sdf = new SimpleDateFormat("MM/dd/yyyy");
    def operation = new Operation()
    operation.name = params.name
    operation.startDate = sdf.parse(params.startDate) + 1
    operation.endDate = sdf.parse(params.endDate) + 1
    operation.bill = Bill.findById(params?.bill?.id)
    operation.type = params.type.toInteger()
    if (operation.save(flush: true)) {
      render('')
    }
  }

  def deleteEvent = {
    println "deleteEvent with id: ${params.id}"
    Operation.findById(params.id).delete()
    render('')
  }

  def moveEvent = {
    def op = Operation.findById(params.id)
    def dayDelta = params.dayDelta.toInteger()
    op.startDate += dayDelta
    op.endDate += dayDelta
    op.save()
    render('')
  }

  def resizeEvent = {
    def op = Operation.findById(params.id)
    op.endDate += params.dayDelta.toInteger()
    op.save()
    render('')
  }

  def events = {
    def data = []
    def billIds = categoryService.usersSelectedBillsIds()

    Operation.list().each {o ->
      if (billIds.contains(o.bill.id)) {
        def map = [:]
        map.put('id', o.id)
        map.put('title', o.name)
        map.put('start', o?.startDate)
        map.put('end', o?.endDate)
        map.put('allDay', false)
        map.put('color', o?.bill?.category.color);
        data.add(map)
      }
    }
    render data as JSON
  }
}
