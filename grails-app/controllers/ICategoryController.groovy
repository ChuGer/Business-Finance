class ICategoryController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [ICategoryInstanceList: ICategory.list(params), ICategoryInstanceTotal: ICategory.count()]
    }

    def create = {
        def ICategoryInstance = new ICategory()
        ICategoryInstance.properties = params
        return [ICategoryInstance: ICategoryInstance]
    }

    def save = {
        def ICategoryInstance = new ICategory(params)
        if (ICategoryInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'ICategory.label', default: 'ICategory'), ICategoryInstance.id])}"
            redirect(action: "show", id: ICategoryInstance.id)
        }
        else {
            render(view: "create", model: [ICategoryInstance: ICategoryInstance])
        }
    }

    def show = {
        def ICategoryInstance = ICategory.get(params.id)
        if (!ICategoryInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
            redirect(action: "list")
        }
        else {
            [ICategoryInstance: ICategoryInstance]
        }
    }

    def edit = {
        def ICategoryInstance = ICategory.get(params.id)
        if (!ICategoryInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [ICategoryInstance: ICategoryInstance]
        }
    }

    def update = {
        def ICategoryInstance = ICategory.get(params.id)
        if (ICategoryInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (ICategoryInstance.version > version) {
                    
                    ICategoryInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ICategory.label', default: 'ICategory')] as Object[], "Another user has updated this ICategory while you were editing")
                    render(view: "edit", model: [ICategoryInstance: ICategoryInstance])
                    return
                }
            }
            ICategoryInstance.properties = params
            if (!ICategoryInstance.hasErrors() && ICategoryInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ICategory.label', default: 'ICategory'), ICategoryInstance.id])}"
                redirect(action: "show", id: ICategoryInstance.id)
            }
            else {
                render(view: "edit", model: [ICategoryInstance: ICategoryInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def ICategoryInstance = ICategory.get(params.id)
        if (ICategoryInstance) {
            try {
                ICategoryInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ICategory.label', default: 'ICategory'), params.id])}"
            redirect(action: "list")
        }
    }
}
