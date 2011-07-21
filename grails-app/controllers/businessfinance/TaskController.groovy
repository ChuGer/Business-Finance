package businessfinance

import grails.converters.JSON
import java.text.SimpleDateFormat
import utils.BillStatCollector
import utils.BillStatHelper
import domain.*

class TaskController {
  static navigation = [
          group: 'tabs',
          order: 3,
          title: "task",
          action: 'index'
  ]
  def springSecurityService
  def categoryService

  def index = {
    def operationInstance = new Operation(type: 1)
    def billInstance = new Bill()
    billInstance.properties = params
    if (springSecurityService.getCurrentUser()) {
      [
              treeData: categoryService.getCategoryTree() as JSON,
              operationInstance: operationInstance,
              billInstance: new Bill(),
              ctgBInstance: new CategoryBill(),
              ctgOInstance: new CategoryOp()
      ]
    }
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
    answer = categoryService.reflectedOpBillCkeck(params.type, params.id[1..-1])
    // TODO: select all persist problem
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]

    render answer as JSON
  }

  def addEvent = {
    //TODO : something more simply?
    def sdf = new SimpleDateFormat("dd/MM/yyyy");
    def operation = new Operation()
    operation.name = params.name
    operation.startDate = sdf.parse(params.startDate) + 1
    def bill = Bill.findById(params.bill.id)
    if (!params.categoryb)
      params.categoryb = 'd1'
    operation.bill = bill
    operation.category = CategoryOp.findById(params.category.id)
    operation.type = Integer.parseInt(params.type)
    operation.isChecked = true
    operation.user = springSecurityService.getCurrentUser()
    operation.sum = params.sum.toFloat()
    if (!operation.save(failOnError: true)) {
      operation.errors.each {
        println it
      }
    }
    else {
      bill.balance += (operation.type == 1) ? operation.sum : -operation.sum
    }
    def answer = categoryService.parseOperById(operation.id)
    render answer as JSON
  }
  def addBill = {
//    println params
    def ctgId = params.categoryb[1..-1]
    def billInstance = new Bill(name: params.name, balance: params.balance.toFloat(), user: springSecurityService.getCurrentUser(),
            currency: Currency.findById(params.currency), category: CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save()) {
      flash.message = "${message(code: 'bill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer = categoryService.parseBillById(billInstance.id)

    render answer as JSON
  }
  def addBillCategory = {
//    println params
    def ctgId = params.categoryb[1..-1]
    def billInstance = new CategoryBill(name: params.name, color: params.color,
            category: CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save()) {
      flash.message = "${message(code: 'ctGbill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer = categoryService.parseCtgBillById(billInstance.id)

    render answer as JSON
  }
  def addOprCategory = {
//    println params
    def ctgId = params.categoryb[1..-1]
    def ctgOpInstance = new CategoryOp(name: params.name, color: params.color,
            category: CategoryOp.findById(ctgId), isChecked: true)
    if (ctgOpInstance.save()) {
      flash.message = "${message(code: 'ctGbill.created.message', args: [message(code: 'bill.label', default: 'Bill'), ctgOpInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), ctgOpInstance.id])}"
    }
    def answer = categoryService.parseCtgOperById(ctgOpInstance.id)

    render answer as JSON
  }

  def deleteEvent = {
//    println "deleteEvent with id: ${params.id}"
    def opr = Operation.findById(params.id)
    if (opr) {
      opr.bill.balance -= (opr.type == 1) ? opr.sum : -opr.sum
      opr.delete()
    }
    render('')
  }

  def moveEvent = {
    def op = Operation.findById(params.id)
    def dayDelta = params.dayDelta.toInteger()
    op.startDate += dayDelta
    op.save()
    render('')
  }

  def clickEvent = {
    if (params.id[0] == 'b') {
      session.clickedId = params.id[1..-1]    // TODO : got 'b'-bill/'o'-opr/'c'-ctgBill/'d'-ctgOp letter prefix
    }
    redirect action: renderStat
  }

  def renderStat = {
    def BillStatCollector stat = new BillStatCollector()
    stat.bill = Bill.findById(session?.clickedId?.toInteger() ?: 1);
    stat.result = new BillStatHelper(categoryName: g.message(code: 'main.stat.category.result'))

    CategoryOp.findAll().each { c ->
      def newHelper = new BillStatHelper(categoryName: c.name)
      c.operations.each {o ->
        if (o.bill.equals(stat.bill)) {
          if (o.type == 1) {
            newHelper.income += o.sum
          } else {
            newHelper.outcome += o.sum
          }
        }
      }
      if (newHelper.income != 0 || newHelper.outcome != 0) {
        newHelper.result = newHelper.income - newHelper.outcome
        stat.result.income += newHelper.income
        stat.result.outcome += newHelper.outcome
        stat.result.result += newHelper.result
        stat.categories.add(newHelper)
      }
    }
    render(template: 'statForm', model: [stat: stat])
  }

  def events = {
//    println new Date(Long.parseLong(params.start))
//    println new Date(Long.parseLong(params.end))
    def data = []
    def opsIds = []
    opsIds = categoryService.usersSelectedOpsIds()
    Operation.findAllByIdInList(opsIds).each {o ->
      if (o.id in opsIds) {
        def map = [:]
        map.put('id', o.id)
        map.put('title', o.name + ' (' + (o.type == 0 ? '-' : '+') + o.sum + ') ')
        map.put('start', o.startDate)
        map.put('allDay', true)
        map.put('color', o.category.color);
        data.add(map)
      }
    }
    render data as JSON
  }

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }
}
