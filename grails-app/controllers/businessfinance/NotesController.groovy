package businessfinance

import domain.CategoryNote
import domain.Note
import domain.auth.SecUser
import grails.converters.JSON
import java.text.SimpleDateFormat

class NotesController {
  def springSecurityService
  def sdf = new SimpleDateFormat("d/M/yyyy");
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

    SecUser user = springSecurityService.getCurrentUser();
    def ctgList = user.notes
    def table = '!'
    def ctg = null
    if (session.categoryNoteId)
      ctg = CategoryNote.findById(session.categoryNoteId)
    if (request.xhr) {
      println 'ajasx'
      def list = Note.findAllByCategory(ctg, params)
      println list
      println list.size()
      def model = [noteList: list, notesTotal: ctg.notes.size()]
      render(template: "noteslist", model: model)
    }
    if (user)
      if (!ctg)
        ctg = user.notes.asList().get(0)
    def noteList = Note.findAllByCategory(ctg, [max: 10, offset: 0])
    [categories: user.notes, noteInstance: new Note(endDate: new Date()), table: table, ctnInstance: new CategoryNote(),
            noteList: noteList, notesTotal: ctg.notes.size(), categoryNoteList: ctgList, initialCtnId: ctg.id]
  }

  def locale = {
    def code = session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: 'ru'
    def locale = [locale: code]
    render locale as JSON
  }

  def categorySelect = {
    if (params.id) {
      def category = CategoryNote.findById(params.id)
      def list = Note.findAllByCategory(category, [max: 10, offset: 0])
      session.categoryNoteId = params.id
      def model = [noteList: list, notesTotal: category.notes.size()]
      render(template: "noteslist", model: model)

    }
  }

  def getNode = {
    def note = Note.findById(params.id)
    def nodeData = [name: note.name, value: note.value, isImportant: note.isImportant, isMade: note.isMade,
            date: note.endDate, ctg: note.category.id, id: note.id]
    render nodeData as JSON
  }

  def manageNote = {
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
        if (params.endDate != '') note.endDate = sdf.parse(params.endDate) + 1
        note.category = CategoryNote.findById(params.category.id)
        note.save(failOnError: true)
        break
      case 'add':
        note = new Note()
        note.name = params.name
        note.value = params.value
        note.isImportant = Boolean.parseBoolean(params._isImportant)
        note.isMade = Boolean.parseBoolean(params._isMade)
        if (params.endDate != '') note.endDate = sdf.parse(params.endDate) + 1
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
    def model = [noteList: list, notesTotal: list.size()]

    if (request.xhr) {
      // ajax request
      render(template: "noteslist", model: model)
    }
    else {
      model
    }
  }

  def addCtn = {
    def ctg = new CategoryNote(name: params.name)
    ctg.save(failOnError: true)
    SecUser user = springSecurityService.getCurrentUser();
    user.notes.add(ctg)
    redirect action: index
  }

  def saveCtn = {
    def ctg = CategoryNote.findById(params.ctnId)
    if (ctg) {
      ctg.name = params.name
      ctg.save(failOnError: true)
    }
    redirect action: index
  }

  def deleteCtn = {
    def ctg = CategoryNote.findById(params.ctnId)
    if (ctg) {
      SecUser user = springSecurityService.getCurrentUser();
      user.notes.remove(ctg)
      ctg.delete()
    }
    redirect action: index
  }
}