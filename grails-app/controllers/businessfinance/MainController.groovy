package businessfinance

import grails.converters.JSON
import domain.Note

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
    [treeData: treeData as JSON, noteInstanceList: Note.list(params), noteInstanceTotal: Note.count()]
  }

  def treeCheck = {
    println params.name + ' with id ' + params.id
    def tdata = [
            [type: 'string', name: 'Task', data: 'Work'],
            [type: 'rf', name: 're', data: 'zo']
    ]
    render tdata as JSON
  }
}
