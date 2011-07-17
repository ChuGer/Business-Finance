package businessfinance

import domain.Bill
import domain.Operation
import grails.converters.JSON
import java.text.SimpleDateFormat
import domain.CategoryOp
import domain.auth.SecUser

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
    if (springSecurityService.getCurrentUser())
      [treeData: categoryService.getCategoryTree() as JSON, operationInstance: operationInstance]
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
