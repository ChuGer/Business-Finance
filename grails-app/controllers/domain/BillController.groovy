package domain

class BillController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [billInstanceList: Bill.list(params), billInstanceTotal: Bill.count()]
    }

    def create = {
        def billInstance = new Bill()
        billInstance.properties = params
        return [billInstance: billInstance]
    }

    def save = {
        def billInstance = new Bill(params)
        if (billInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
            redirect(action: "show", id: billInstance.id)
        }
        else {
            render(view: "create", model: [billInstance: billInstance])
        }
    }

    def show = {
        def billInstance = Bill.get(params.id)
        if (!billInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
            redirect(action: "list")
        }
        else {
            [billInstance: billInstance]
        }
    }

    def edit = {
        def billInstance = Bill.get(params.id)
        if (!billInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [billInstance: billInstance]
        }
    }

    def update = {
        def billInstance = Bill.get(params.id)
        if (billInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (billInstance.version > version) {
                    
                    billInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'bill.label', default: 'Bill')] as Object[], "Another user has updated this Bill while you were editing")
                    render(view: "edit", model: [billInstance: billInstance])
                    return
                }
            }
            billInstance.properties = params
            if (!billInstance.hasErrors() && billInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'bill.label', default: 'Bill'), billInstance.id])}"
                redirect(action: "show", id: billInstance.id)
            }
            else {
                render(view: "edit", model: [billInstance: billInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def billInstance = Bill.get(params.id)
        if (billInstance) {
            try {
                billInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'bill.label', default: 'Bill'), params.id])}"
            redirect(action: "list")
        }
    }
}
