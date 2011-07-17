package businessfinance

import grails.converters.JSON
import java.text.SimpleDateFormat
import domain.*

class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: "main",
          action: 'index'
  ]
  def springSecurityService
  def categoryService

  def index = {
    def operationInstance = new Operation()
    def billInstance = new Bill()
    billInstance.properties = params
    if (springSecurityService.getCurrentUser())
      [treeData: categoryService.getCategoryTree() as JSON, operationInstance: operationInstance, billInstance: billInstance]
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
    def answer =  [id: '4' ]
    render  answer as JSON
  }

  def addEvent = {
    println params
    //TODO : something more simply?
    def sdf = new SimpleDateFormat("MM/dd/yyyy");
    def operation = new Operation()
    operation.name = params.name
    operation.startDate = sdf.parse(params.startDate) + 1
    operation.endDate = sdf.parse(params.endDate) + 1
    operation.bill = Bill.findById(params?.bill?.id)
    operation.category = CategoryOp.findById(params?.category?.id)
    operation.type = params.type.toInteger()
    operation.user = springSecurityService.getCurrentUser()
    operation.sum = Float.parseFloat(params.sum)
    if (!operation.save()) {
      operation.errors.each {
        println it
      }
    }
    render('')
  }
  def addBill = {
//    println params
    def ctgId = params.categoryb[1..-1]
    def billInstance = new Bill(name: params.name, balance: params.balance.toFloat(),user : springSecurityService.getCurrentUser(),
                                currency: Currency.findById(params.currency), category : CategoryBill.findById(ctgId), isChecked: true,)
    if (billInstance.save()) {
      flash.message = "${message(code: 'bill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer =  categoryService.parseBillById(billInstance.id)

    render answer as JSON
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
    def opsIds = categoryService.usersSelectedOpsIds()
    def billIds = categoryService.usersSelectedBillsIds()
    println opsIds + ' ' +  billIds
    Operation.list().each {o ->
      if (o.id in opsIds) {
        def map = [:]
        map.put('id', o.id)
        map.put('title', o.name)
        map.put('start', o.startDate)
        map.put('end', o?.endDate)
        map.put('allDay', true)
        map.put('color', o.category.color);
        data.add(map)
      }
    }
    render data as JSON
  }

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE';
    def locale = [locale: code]
    render locale as JSON
  }
}
