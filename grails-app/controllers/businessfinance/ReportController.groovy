package businessfinance

import grails.converters.JSON

class ReportController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "report",
          action: 'index'
  ]
  def index = {}

  def lineChart = {
    def lineChart = [
            [type: 'date', name: 'Data', data: [[2008, 1, 1], [2008, 2, 1], [2008, 3, 1]]],
            [type: 'number', name: 'Hours per Day', data: [11, 34, 465]],
            [type: 'number', name: 'Sales', data: [345, 3, 465]],
            [type: 'number', name: 'Sales2', data: [345, 3, 465]],
            [type: 'string', name: 'Task', data: ['Work', 'Eats', 'Comute']]
    ];
    render lineChart as JSON
  }

  def pieChart = {
    def pieChart = [
            cols: [
                    [id: 'A', label: 'NEW A', type: 'string'],
                    [id: 'B', label: 'B-label', type: 'number'],
                    [id: 'C', label: 'C-label', type: 'date']
            ],
            rows: [
                    [c: [
                            [v: 'a'],
                            [v: 3, f: 'One'],
                            [v: new Date(2008, 1, 28, 0, 31, 26), f: '2/28/08 12:31 AM']
                    ]],
                    [c: [
                            [v: 'b'],
                            [v: 5, f: 'Two'],
                            [v: new Date(2008, 2, 30, 0, 31, 26), f: '3/30/08 12:31 AM']
                    ]],
                    [c: [
                            [v: 'c'],
                            [v: 80, f: 'Three'],
                            [v: new Date(2008, 3, 30, 0, 31, 26), f: '4/30/08 12:31 AM']
                    ]]
            ]

    ]
    render pieChart as JSON

  }
}