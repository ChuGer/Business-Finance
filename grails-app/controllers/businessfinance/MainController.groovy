package businessfinance

import grails.converters.JSON

class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: 'Главная страница',
          action: 'index'
  ]

  def index = {
    def treeData = [
            [data: 'woof', attr: [id: '23'], children: [[[data: 'Child zzz', attr: [id: '26']],
                    [data: 'poog', attr: [id: '11'], children: [[[data: 'Child t', attr: [id: '31']], [data: 'Rert t', attr: [id: '33']]]]]]]],
            [data: 'poog', attr: [id: '18'], children: [[[data: 'Child t', attr: [id: '29']], [data: 'Chagur', attr: [id: '34']]]]]
    ];
    [treeData: treeData as JSON]
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
