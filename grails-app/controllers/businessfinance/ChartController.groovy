package businessfinance

import grails.converters.JSON

class ChartController {

  def index = {

//    def labelsMap = ['a', 'b', 'c']
//    def dataMap = [3241, 4352, 345]
//    [
//            chartData: [
//                    labels: labelsMap,
//                    values: dataMap,
//                    size: [400, 400],
//                    colors: ['FF0000', '00ff00', '0000ff'],
//                    axesLabels: [0: labelsMap, 1: dataMap]
//            ]
//    ]
//    def tableData = [
//            [type: 'string', name: 'Task', data: ['Work', 'Eat', 'Comute', 'Watch', 'Pizza', 'Artem', 'Comute', 'Watch', 'Pizza', 'Artem']],
//            [type: 'number', name: 'Hours per Day', data: [11, 34, 465, 34, 54, 235, 465, 34, 54, 235]],
//            [type: 'number', name: 'Hours sadf Day', data: [234, 34, 465, 5, 54, 235, 465, 5, 54, 235]],
//            [type: 'number', name: 'Sales', data: [345, 3, 234, 245, 563, 352, 34, 54, 235, 465]]
//    ];

    def chartData = [
            [type: 'date', name: 'Data', data: [[2008, 1, 1], [2008, 2, 1], [2008, 3, 1]]],
            [type: 'number', name: 'Hours per Day', data: [11, 34, 465]],
            [type: 'number', name: 'Sales', data: [345, 3, 465]],
            [type: 'number', name: 'Sales2', data: [345, 3, 465]],
            [type: 'string', name: 'Task', data: ['Work', 'Eats', 'Comute']]
    ];
    [chartData: chartData as JSON]
  }

}
