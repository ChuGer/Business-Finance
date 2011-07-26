package businessfinance

import domain.CategoryNote
import domain.Note
import domain.auth.SecUser
import grails.converters.JSON
import java.text.SimpleDateFormat

class NotesController {
  def springSecurityService
  def sdf = new SimpleDateFormat("dd/MM/yyyy");
  static navigation = [
          group: 'tabs',
          order: 5,
          title: 'note',
          action: 'index'
  ]
  def userService
  def index = {
    userService.saveUserInfo(this.class.simpleName)
    if (params.max)
      params.max = Math.min(params.max ? params.int('max') : 20, 100)

    def categories = []
    SecUser user = springSecurityService.getCurrentUser();
    def table = '!'
    if (request.xhr) {
      def ctg = CategoryNote.findById(session.categoryNoteId)
      params.id = 8
      println params
      def list = Note.findAllByCategory(ctg, params)
      def model = [noteList: list, notesTotal: list.count()]
      render(template: "noteslist", model: model)
    }
    if (user)
      categories = user.notes

    println 'index'
    [categories: categories, noteInstance: new Note(endDate: new Date()), table: table,
            noteList: categories.asList().get(0).notes, notesTotal: categories.asList().get(0).notes.size()]
  }
  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }
  def categorySelect = {
    println 'ctgsel'
    println params
    if (params.id) {
      def list = CategoryNote.findById(params.id).notes
      session.categoryNoteId = params.id
      def table = render(template: 'noteslist', model: [noteList: list, notesTotal: list.size()])
      table
    }
  }
  def getNode = {
    def note = Note.findById(params.id)
    def nodeData = [name: note.name, value: note.value, isImportant: note.isImportant, isMade: note.isMade,
            date: note.endDate, ctg: note.category.id, id: note.id]
    render nodeData as JSON
//    render(template: 'note', model: [noteInstance: note])
  }

  def manageNote = {
    println 'ssaving'
    println params
    def note = Note.findById(params.noteId)
    //TODO: if (note) {
    int cId = params.category.id.toInteger()
    switch (params.actName) {
      case 'del':
        note.delete()
        break
      case 'save':
        note.name = params.name
        note.value = params.value
        note.isImportant = Boolean.parseBoolean(params._isImportant)
        note.isMade = Boolean.parseBoolean(params._isMade)
        //if(params.endDate != '')note.endDate = sdf.parse(params.endDate) + 1  //TODO parse date
        note.category = CategoryNote.findById(params.category.id)
        note.save(failOnError: true)
        break
      case 'add':
        note = new Note()
        note.name = params.name
        note.value = params.value
        note.isImportant = Boolean.parseBoolean(params._isImportant)
        note.isMade = Boolean.parseBoolean(params._isMade)
        //if(params.endDate != '')note.endDate = sdf.parse(params.endDate) + 1  //TODO parse date
        note.category = CategoryNote.findById(params.category.id)
        note.save(failOnError: true)
        break

    }


    def answer = [cId: cId]
    render answer as JSON
  }
  def isMadeTrigger = {
    if (params.id) {
      def note = Note.findById(params.id)
      note.isMade = !note.isMade
    }
  }

  def noteList = {
    def list = CategoryNote.findById(session.categoryNoteId).notes
    params.max = Math.min(params.max ? params.int('max') : 20, 100)
    def model = [noteList: list, notesTotal: list.count()]

    if (request.xhr) {
      // ajax request
      render(template: "noteslist", model: model)
    }
    else {
      model
    }
  }
}