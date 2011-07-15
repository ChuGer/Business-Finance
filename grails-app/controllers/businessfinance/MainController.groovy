package businessfinance

import grails.converters.JSON
import domain.Note
import domain.Category
import domain.Bill
import domain.Operation

class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: 'Главная страница',
          action: 'index'
  ]
  def springSecurityService
  def parseEntityData(Bill bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: bill.id, type:'bill'])
    data.add(inn)
    data
  }

  def parseCategoryData() {
    def data = []
    Category.list().each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: c.id,type : 'ctgr'])
      def childs = []
      c.bills.each {b ->
        childs.add(parseEntityData(b))
      }
      inn.put('children', childs)
      data.add(inn)
    }
    data
  }

  def index = {
    if( springSecurityService.getCurrentUser() )
    [treeData: parseCategoryData() as JSON]
    else{
      def treeData = [
            [data: 'ExCateg1', attr: [id: '23'], children: [[[data: 'Bill1', attr: [id: '26']],
                    [data: 'bill2', attr: [id: '11']  ]  ]]],
            [data: 'ExCateg2', attr: [id: '18'], children: [[[data: 'bill t', attr: [id: '29']], [data: 'Chagur', attr: [id: '34']]]]]
    ];
      [treeData: treeData as JSON]
    }
  }

  def treeCheck = {
    println params.name + ' with id ' + params.id + ' is ' + params.type
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]
//    render tdata as JSON
  }

  def addEvent = {
    println params
    def operationInstance = new Operation(params)
    if (operationInstance.save(flush: true)) {
      flash.message = "${message(code: 'default.created.message', args: [message(code: 'operation.label', default: 'Operation'), operationInstance.id])}"
    }
    render('')
  }

  def deleteEvent = {
    println "deleteEvent with id: ${params.id}"
    Operation.findById(params.id).delete()
    render('')
  }

  def moveEvent = {
    def op = Operation.findById(params.id)
    op.startDate += params.dayDelta.toInteger()
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
    Operation.list().each {o ->
      def map = [:]
      map.put('id', o.id)
      map.put('title', o.name)
      map.put('start', o?.startDate)
      map.put('end', o?.endDate)
      map.put('allDay', false)
      map.put('color', o?.bill?.color);
      data.add(map)
    }
    render data as JSON
  }
}
