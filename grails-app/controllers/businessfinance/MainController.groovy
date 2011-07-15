package businessfinance

import grails.converters.JSON
import domain.Note
import domain.Category
import domain.Bill

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
//    println "${params.startDate} ${params.endDate}"
    session.events.add([id: getRandom(), title: params.name, start: params.startDate, end: params.endDate, allDay: false])
    render('')
  }

  def deleteEvent = {
    println "deleteEvent with id: ${params.id}"
    render('OK')
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
//    def start = params.start.toLong()
//    def today = params._.toLong()
//    def end = params.end.toLong()
//    println new Date(today-start-end)
//    println new Date(today+end+start)
    if (session.events == null) {
      session.events = [getRandomEvent()]
    }
    def events = session.events
    render events as JSON
  }

  def clearCalendar = {
    session.events = null
  }

  def showCalendar = {
    session.events.add(getRandomEvent())
  }

  def getRandom() {
    new Random().nextInt(10000).toString()
  }

  def getRandomEvent() {
    [id: getRandom(), title: getRandom(), start: new Date(), allDay: false, color: 'red']
  }
}
