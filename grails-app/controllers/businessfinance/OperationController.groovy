package businessfinance

import domain.Bill
import domain.CategoryBill
import domain.CategoryOp
import domain.Operation
import domain.auth.SecUser
import grails.converters.JSON
import java.text.SimpleDateFormat

class OperationController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "operation",
          action: 'index'
  ]

  def springSecurityService
  def categoryService

  def index = {
    def treeData = categoryService.getBillTree()
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
    operation.user = springSecurityService.getCurrentUser()
    operation.sum = params.sum.toFloat()
    if (!operation.save()) {
      operation.errors.each {
        println it
      }
    }
    render('')
  }

  def addBill = {
    def ctgId = params.categoryb
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

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }

  def incomeTable = {
    SecUser user = springSecurityService.currentUser
    if (user) {
      def newCat = createCategorySkilet(user.categoriesO, 1, getClickedBillId())
      render(template: 'table', model: [rootCat: newCat])
    }
  }

  def outcomeTable = {
    SecUser user = springSecurityService.currentUser
    if (user) {
      def newCat = createCategorySkilet(user.categoriesO, 0, getClickedBillId())
      render(template: 'table', model: [rootCat: newCat])
    }
  }

  def getClickedBillId() {
    session.startDate = session.startDate ?: new Date()
    session.endDate = session.endDate ?: new Date();
    session.clickedId?.toInteger() ?: 1
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
