package businessfinance

import grails.converters.JSON
import domain.Category
import domain.Bill

class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: 'Главная страница',
          action: 'index'
  ]

  def parseEntityData(Bill bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: bill.id])
    data.add(inn)
    data
  }

  def parseCategoryData() {
    def data = []
    Category.list().each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: c.id])
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
    [treeData: parseCategoryData() as JSON]
  }

  def treeCheck = {
    println params.name + ' with id ' + params.id
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]
    render tdata as JSON
  }

  def addEvent = {
    session.events.add([id: getRandom(), title: params.name, start: new Date(params.startDate) + 1, end: new Date(params.endDate) + 1, allDay: false])
  }

  def deleteEvent = {
    println "deleteEvent with id: ${params.id}"
    render('')
  }

  def moveEvent = {
    println "moveEvent with id: ${params.id}, dayDelta: ${params.dayDelta}"
    render('')
  }

  def resizeEvent = {
    println "resizeEvent with id: ${params.id}, dayDelta: ${params.dayDelta}"
    render('')
  }
  def events = {
    if (session.events == null) {
      session.events = [getRandomEvent()]
    }
    def events = session.events
    render events as JSON
  }

  def clearCalendar = {
    session.events = null
  }

//  def showCalendar = {
//    session.events.add(getRandomEvent())
//  }
//
//  def getRandom() {
//    new Random().nextInt(10000).toString()
//  }
//
//  def getRandomEvent() {
//    [id: getRandom(), title: getRandom(), start: new Date(), allDay: false, color: 'red']
//  }
}
