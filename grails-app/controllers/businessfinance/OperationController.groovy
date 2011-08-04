package businessfinance

import grails.converters.JSON
import java.text.SimpleDateFormat
import domain.*

class OperationController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "operation",
          action: 'index'
  ]

  def fetchService
  def persistService
  def userService

  def index = {
    userService.saveUserInfo(this.class.simpleName)

    def treeData = fetchService.getBillTree()
    def operationInstance = new Operation(type: 1)
    [
            operationInstance: operationInstance,
            billInstance: new Bill(),
            ctgBInstance: new CategoryBill(),
            treeData: treeData as JSON
    ]
  }

  def addEvent = {
    //TODO : something more simply?
    def sdf = new SimpleDateFormat("dd/MM/yyyy");
    def operation = new Operation()
    operation.name = params.name
    operation.startDate = sdf.parse(params.startDate) + 1
    operation.bill = Bill.findById(params.bill.id)
    def category = CategoryOp.findById(params.category.id)
    operation.category = category
    operation.type = Integer.parseInt(params.type)
    operation.isChecked = true
    operation.user = userService.getUser()
    operation.sum = params.sum.toFloat()
    if (!operation.save()) {
      operation.errors.each {
        println it
      }
    }
    render('')
  }

  def addBill = {
    def ctgId = params.categoryb[1..-1].toInteger()
    def billInstance = new Bill(name: params.name, balance: params.balance.toFloat(), user: userService.getUser(),
            currency: Currency.findById(params.currency.toInteger()), category: CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save(failOnError: true)) {
      flash.message = "${message(code: 'bill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer = fetchService.parseBillById(billInstance.id)
    render answer as JSON
  }

  def addBillCategory = {
    def ctgId = params.categoryb[1..-1]
    def billInstance = new CategoryBill(name: params.name, color: params.color,
            category: CategoryBill.findById(ctgId), isChecked: true)
    if (billInstance.save()) {
      flash.message = "${message(code: 'ctGbill.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.name])}"
      println "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
    }
    def answer = fetchService.parseCtgBillById(billInstance.id)
    render answer as JSON
  }

  def locale = {
    render userService.getUserLocale() as JSON
  }

  def incomeTable = {
    def newCat = createCategorySkilet(userService.getUser().categoriesO, 1, getClickedBillId())
    render(template: 'table', model: [rootCat: newCat])
  }

  def outcomeTable = {
    def newCat = createCategorySkilet(userService.getUser().categoriesO, 0, getClickedBillId())
    render(template: 'table', model: [rootCat: newCat])
  }

  def getClickedBillId() {
    session.startDate = session.startDate ?: new Date("1/1/2011")
    session.endDate = session.endDate ?: new Date();
    session.clickedId?.toInteger() ?: Bill.findByName("Cash")?.id
  }

  // TODO: SQL

  def createCategorySkilet(rootCat, type, billId) {
    def skilet = new CategoryOp()
    skilet.name = rootCat.name
    skilet.color = rootCat.color
    skilet.categories = []
    skilet.operations = []

    rootCat.operations.each {o ->
      if (o.type == type && o.bill.id == billId && (o.startDate >= session.startDate && o.startDate <= session.endDate)) {
        skilet.operations.add(o);
      }
    }

    if (!(skilet.operations.empty && rootCat.categories.empty)) {
      rootCat.categories.each {cat ->
        def subCat = createCategorySkilet(cat, type, billId)
        if (subCat) {
          skilet.categories.add(subCat)
        }
      }
      skilet
    }
  }

  def clickEvent = {
    if (params.id[0] == 'b') {
      session.clickedId = params.id[1..-1]    // TODO : got 'b'-bill/'o'-opr/'c'-ctgBill/'d'-ctgOp letter prefix
    }
  }

  def changeDateRange = {
    def sdf = new SimpleDateFormat("M/d/yyyy")
    session.startDate = sdf.parse(params.startDate)
    session.endDate = sdf.parse(params.endDate)
    render('')
  }
}
