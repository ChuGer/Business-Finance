package businessfinance

import domain.auth.SecUser
import domain.CategoryOp
import domain.Operation
import java.text.SimpleDateFormat
import domain.Bill
import grails.converters.JSON

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
    SecUser user = springSecurityService.getCurrentUser()
    if (user) {
      def rootCat = user.categoriesO
      def operationInstance = new Operation(type: 1)
      [
              operationInstance: operationInstance,
              rootCat: rootCat
      ]
    }
  }

  def recursiveRemoveOps(CategoryOp rootCat) {
    rootCat.categories.each {c ->
      c.operations.each {o ->
        if (o.type != 1) {
          c.removeFromOperations(o)
          println 'remove op' + o
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

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }
}
