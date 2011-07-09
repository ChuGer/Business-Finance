class BaseController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [baseInstanceList: Base.list(params), baseInstanceTotal: Base.count()]
    }

    def create = {
        def baseInstance = new Base()
        baseInstance.properties = params
        return [baseInstance: baseInstance]
    }

    def save = {
        def baseInstance = new Base(params)
        if (baseInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'base.label', default: 'Base'), baseInstance.id])}"
            redirect(action: "show", id: baseInstance.id)
        }
        else {
            render(view: "create", model: [baseInstance: baseInstance])
        }
    }

    def show = {
        def baseInstance = Base.get(params.id)
        if (!baseInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
            redirect(action: "list")
        }
        else {
            [baseInstance: baseInstance]
        }
    }

    def edit = {
        def baseInstance = Base.get(params.id)
        if (!baseInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [baseInstance: baseInstance]
        }
    }

    def update = {
        def baseInstance = Base.get(params.id)
        if (baseInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (baseInstance.version > version) {
                    
                    baseInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'base.label', default: 'Base')] as Object[], "Another user has updated this Base while you were editing")
                    render(view: "edit", model: [baseInstance: baseInstance])
                    return
                }
            }
            baseInstance.properties = params
            if (!baseInstance.hasErrors() && baseInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'base.label', default: 'Base'), baseInstance.id])}"
                redirect(action: "show", id: baseInstance.id)
            }
            else {
                render(view: "edit", model: [baseInstance: baseInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def baseInstance = Base.get(params.id)
        if (baseInstance) {
            try {
                baseInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'base.label', default: 'Base'), params.id])}"
            redirect(action: "list")
        }
    }
}
