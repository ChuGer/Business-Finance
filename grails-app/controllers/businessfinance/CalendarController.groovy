package businessfinance

import grails.converters.JSON

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
    def events = [
            [id : 1, title : 'ALOE', start: new Date(), end: new Date(), allDay : false, color : 'red'],
            [title : 'ALOE2', start: new Date(), end: new Date(), allDay : false, color : '#3D3D3D']
    ]
    render events as JSON
  }
}
