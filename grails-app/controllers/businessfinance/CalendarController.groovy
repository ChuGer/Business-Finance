package businessfinance

import grails.converters.JSON
import java.text.SimpleDateFormat

class CalendarController {

  def index = {
    def calendarData = [
            [id: 1, title: 'Data', data: [[2008, 1, 1], [2008, 2, 1], [2008, 3, 1]]],
            [type: 'number', name: 'Hours per Day', data: [11, 34, 465]],
            [type: 'number', name: 'Sales', data: [345, 3, 465]],
            [type: 'number', name: 'Sales2', data: [345, 3, 465]],
            [type: 'string', name: 'Task', data: ['Work', 'Eats', 'Comute']]
    ];
    [calendarData: calendarData as JSON]
  }

  def savedata = {
    def json = request.JSON
    def povar = [a: 'povar']
    render povar as JSON
  }

  def events = {
    if (session.events == null) {
      session.events = [getRandomEvent()]
    }
    def events = session.events
    render events as JSON
  }

  def showCalendar = {
    session.events.add(getRandomEvent())
  }

  def clearCalendar = {
    session.events = null
  }

  def getRandom() {
    new Random().nextInt(10000).toString()
  }

  def getRandomEvent() {
    [id: getRandom(), title: getRandom(), start: new Date(), allDay: false, color: 'red']
  }

  def aloe = {
    session.events.add([id: getRandom(), title: params.name, start: new Date(params.startDate) + 1, end: new Date(params.endDate) + 1, allDay: false])
  }

  def deleteEvent = {
    println "delete Event with id: ${params.id}"
    render('')
  }

  def moveEvent = {
    println "move Event with id: ${params.id}, dayDelta: ${params.dayDelta}"
    render('')
  }

  def resizeEvent = {
    println "resize Event with id: ${params.id}, dayDelta: ${params.dayDelta}"
    render('')
  }
}
