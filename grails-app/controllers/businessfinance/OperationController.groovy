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
      println  treeData
      def operationInstance = new Operation(type: 1)
      [
              operationInstance: operationInstance,
              rootCat: rootCat,
              billInstance: new Bill(),
              ctgBInstance: new CategoryBill(),
              treeData : treeData as JSON
      ]
    }
  }

  def recursiveRemoveOps(CategoryOp rootCat) {
    rootCat.categories.each {c ->
      c.operations.each {o ->
        if (o.type != 1) {
          c.removeFromOperations(o)
        }
      }
      c.categories.each {ch ->
        recursiveRemoveOps(ch)
      }
    }
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

  def createTable = {
    SecUser user = springSecurityService.currentUser
    if (user) {
      render(template: 'table', model: [rootCat: user.categoriesO])
    }
  }
}
