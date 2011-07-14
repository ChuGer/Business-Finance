package domain

class OperationController {
     static navigation = [
		group:'tabs',
		order:3 ,
		title:'Operation',
		action:'list'
	]
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [operationInstanceList: Operation.list(params), operationInstanceTotal: Operation.count()]
    }

    def create = {
        def operationInstance = new Operation()
        operationInstance.properties = params
        return [operationInstance: operationInstance]
    }

    def save = {
        def operationInstance = new Operation(params)
        if (operationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'operation.label', default: 'Operation'), operationInstance.id])}"
            redirect(action: "show", id: operationInstance.id)
        }
        else {
            render(view: "create", model: [operationInstance: operationInstance])
        }
    }

    def show = {
        def operationInstance = Operation.get(params.id)
        if (!operationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [operationInstance: operationInstance]
        }
    }

    def edit = {
        def operationInstance = Operation.get(params.id)
        if (!operationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [operationInstance: operationInstance]
        }
    }

    def update = {
        def operationInstance = Operation.get(params.id)
        if (operationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (operationInstance.version > version) {
                    
                    operationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'operation.label', default: 'Operation')] as Object[], "Another user has updated this Operation while you were editing")
                    render(view: "edit", model: [operationInstance: operationInstance])
                    return
                }
            }
            operationInstance.properties = params
            if (!operationInstance.hasErrors() && operationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'operation.label', default: 'Operation'), operationInstance.id])}"
                redirect(action: "show", id: operationInstance.id)
            }
            else {
                render(view: "edit", model: [operationInstance: operationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def operationInstance = Operation.get(params.id)
        if (operationInstance) {
            try {
                operationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'operation.label', default: 'Operation'), params.id])}"
            redirect(action: "list")
        }
    }
}
