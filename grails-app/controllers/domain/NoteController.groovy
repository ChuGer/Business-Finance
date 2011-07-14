package domain

import grails.converters.JSON

class NoteController {
    static navigation = [
		group:'tabs',
		order:5,
		title:'Tree show',
		action:'list'
	]

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def treeData = [
            [data: 'woof',  attr: [id : '23'], children: [[ [data: 'Child zzz',  attr: [id : '26'] ],
                    [data: 'poog', attr: [id : '11'], children: [[ [data: 'Child t',  attr: [id : '31'] ], [data: 'Rert t',  attr: [id : '33'] ] ] ]] ] ]],
            [data: 'poog', attr: [id : '18'], children: [[ [data: 'Child t',  attr: [id : '29'] ] , [data: 'Chagur',  attr: [id : '34'] ] ] ]]
    ];
        [treeData: treeData as JSON, noteInstanceList: Note.list(params), noteInstanceTotal: Note.count()]
    }
    def zub = {
      println params.gender
      def tdata = [
              [type: 'string', name: 'Task', data:'Work'],
              [type: 'rf', name: 're', data:'zo']
      ]
        render tdata as JSON
    }
      def treeCheck = {
      println params.name + ' with id '+params.id
      def tdata = [
              [type: 'string', name: 'Task', data:'Work'],
              [type: 'rf', name: 're', data:'zo']
      ]
        render tdata as JSON
    }
//    if (params?.format && params.format != "html") {
  //    response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
    //  response.setHeader("Content-disposition", "attachment; filename=books.${params.extension}")
     // exportService.export(params.format, response.outputStream, Note.list(params), [:], [:])
   // }
    def create = {
        def noteInstance = new Note()
        noteInstance.properties = params
        return [noteInstance: noteInstance]
    }

    def save = {
        def noteInstance = new Note(params)
        if (noteInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'note.label', default: 'Note'), noteInstance.id])}"
            redirect(action: "show", id: noteInstance.id)
        }
        else {
            render(view: "create", model: [noteInstance: noteInstance])
        }
    }

    def show = {
        def noteInstance = Note.get(params.id)
        if (!noteInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
            redirect(action: "list")
        }
        else {
            [noteInstance: noteInstance]
        }
    }

    def edit = {
        def noteInstance = Note.get(params.id)
        if (!noteInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [noteInstance: noteInstance]
        }
    }

    def update = {
        def noteInstance = Note.get(params.id)
        if (noteInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (noteInstance.version > version) {
                    
                    noteInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'note.label', default: 'Note')] as Object[], "Another user has updated this Note while you were editing")
                    render(view: "edit", model: [noteInstance: noteInstance])
                    return
                }
            }
            noteInstance.properties = params
            if (!noteInstance.hasErrors() && noteInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'note.label', default: 'Note'), noteInstance.id])}"
                redirect(action: "show", id: noteInstance.id)
            }
            else {
                render(view: "edit", model: [noteInstance: noteInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def noteInstance = Note.get(params.id)
        if (noteInstance) {
            try {
                noteInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'note.label', default: 'Note'), params.id])}"
            redirect(action: "list")
        }
    }
}
