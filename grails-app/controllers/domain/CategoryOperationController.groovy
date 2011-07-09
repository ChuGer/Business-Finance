package domain

class CategoryOperationController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [categoryOperationInstanceList: CategoryOperation.list(params), categoryOperationInstanceTotal: CategoryOperation.count()]
    }

    def create = {
        def categoryOperationInstance = new CategoryOperation()
        categoryOperationInstance.properties = params
        return [categoryOperationInstance: categoryOperationInstance]
    }

    def save = {
        def categoryOperationInstance = new CategoryOperation(params)
        if (categoryOperationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), categoryOperationInstance.id])}"
            redirect(action: "show", id: categoryOperationInstance.id)
        }
        else {
            render(view: "create", model: [categoryOperationInstance: categoryOperationInstance])
        }
    }

    def show = {
        def categoryOperationInstance = CategoryOperation.get(params.id)
        if (!categoryOperationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [categoryOperationInstance: categoryOperationInstance]
        }
    }

    def edit = {
        def categoryOperationInstance = CategoryOperation.get(params.id)
        if (!categoryOperationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [categoryOperationInstance: categoryOperationInstance]
        }
    }

    def update = {
        def categoryOperationInstance = CategoryOperation.get(params.id)
        if (categoryOperationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (categoryOperationInstance.version > version) {
                    
                    categoryOperationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'categoryOperation.label', default: 'CategoryOperation')] as Object[], "Another user has updated this CategoryOperation while you were editing")
                    render(view: "edit", model: [categoryOperationInstance: categoryOperationInstance])
                    return
                }
            }
            categoryOperationInstance.properties = params
            if (!categoryOperationInstance.hasErrors() && categoryOperationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), categoryOperationInstance.id])}"
                redirect(action: "show", id: categoryOperationInstance.id)
            }
            else {
                render(view: "edit", model: [categoryOperationInstance: categoryOperationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def categoryOperationInstance = CategoryOperation.get(params.id)
        if (categoryOperationInstance) {
            try {
                categoryOperationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryOperation.label', default: 'CategoryOperation'), params.id])}"
            redirect(action: "list")
        }
    }
}
