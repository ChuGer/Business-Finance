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
      [treeData: categoryService.getCategoryTree() as JSON, operationInstance: operationInstance,
              billInstance: new Bill() , ctgBInstance : new CategoryBill(), ctgOInstance : new CategoryOp()]
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
     def answer = []
      answer   = categoryService.reflectedOpBillCkeck(params.type, params.id[1..-1])
    // TODO: select all persist problem
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]

    render  answer as JSON
  }

  def addEvent = {
    println params
    //TODO : something more simply?
    def sdf = new SimpleDateFormat("dd/MM/yyyy");
    def operation = new Operation()
    operation.name = params.name
    operation.startDate = sdf.parse(params.startDate) + 1
    operation.endDate = sdf.parse(params.endDate) + 1
    operation.bill = Bill.findById(params.bill.id)
    operation.category = CategoryOp.findById(params?.categoryb[1..-1])   // TODO synchronize inlist with hovered
    operation.type = params.type
    operation.isChecked = true
    operation.user = springSecurityService.getCurrentUser()
    operation.sum = params.sum.toFloat()
    if (!operation.save(failOnError: true)) {
      operation.errors.each {
        println it
      }
    }
    println 'created : ' +  (operation  as JSON)
    def answer =  categoryService.parseOperById(operation.id)
    render answer as JSON
  }
  def addBill = {
//    println params
    def ctgId = params.categoryb[1..-1]
    def billInstance = new Bill(name: params.name, balance: params.balance.toFloat(),user : springSecurityService.getCurrentUser(),
                                currency: Currency.findById(params.currency), category : CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save()) {
      flash.message = "${message(code: 'bill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer =  categoryService.parseBillById(billInstance.id)

    render answer as JSON
  }
  def addBillCategory = {
    println params
    def ctgId = params.categoryb[1..-1]
    def billInstance = new CategoryBill(name: params.name, color : params.color,
                                  category : CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save()) {
      flash.message = "${message(code: 'ctGbill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer =  categoryService.parseCtgBillById(billInstance.id)

    render answer as JSON
  }
  def addOprCategory = {
    println params
    def ctgId = params.categoryb[1..-1]
    def ctgOpInstance = new CategoryOp(name: params.name, color : params.color,
                                  category : CategoryOp.findById(ctgId), isChecked: true)
    if (ctgOpInstance.save()) {
      flash.message = "${message(code: 'ctGbill.created.message', args: [message(code: 'bill.label', default: 'Bill'), ctgOpInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), ctgOpInstance.id])}"
    }
    def answer =  categoryService.parseCtgOperById(ctgOpInstance.id)

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
    def opsIds = []
    opsIds = categoryService.usersSelectedOpsIds()
//    def billIds = categoryService.usersSelectedBillsIds()
    Operation.findAllByIdInList(opsIds).each {o ->
      if (o.id in opsIds) {
        def map = [:]
        map.put('id', o.id)
        map.put('title', o.name + ' ('+ (o.type==0 ?'-':'+') + o.sum + ') ')
        map.put('start', o.startDate)
        map.put('end', o?.endDate)
        map.put('allDay', true)
        map.put('color', o.category.color);
        data.add(map)
      }
    }
    println  opsIds
    render data as JSON
  }

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }
}
