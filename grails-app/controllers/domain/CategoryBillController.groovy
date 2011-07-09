package domain

class CategoryBillController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [categoryBillInstanceList: CategoryBill.list(params), categoryBillInstanceTotal: CategoryBill.count()]
    }

    def create = {
        def categoryBillInstance = new CategoryBill()
        categoryBillInstance.properties = params
        return [categoryBillInstance: categoryBillInstance]
    }

    def save = {
        def categoryBillInstance = new CategoryBill(params)
        if (categoryBillInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), categoryBillInstance.id])}"
            redirect(action: "show", id: categoryBillInstance.id)
        }
        else {
            render(view: "create", model: [categoryBillInstance: categoryBillInstance])
        }
    }

    def show = {
        def categoryBillInstance = CategoryBill.get(params.id)
        if (!categoryBillInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
            redirect(action: "list")
        }
        else {
            [categoryBillInstance: categoryBillInstance]
        }
    }

    def edit = {
        def categoryBillInstance = CategoryBill.get(params.id)
        if (!categoryBillInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [categoryBillInstance: categoryBillInstance]
        }
    }

    def update = {
        def categoryBillInstance = CategoryBill.get(params.id)
        if (categoryBillInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (categoryBillInstance.version > version) {
                    
                    categoryBillInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'categoryBill.label', default: 'CategoryBill')] as Object[], "Another user has updated this CategoryBill while you were editing")
                    render(view: "edit", model: [categoryBillInstance: categoryBillInstance])
                    return
                }
            }
            categoryBillInstance.properties = params
            if (!categoryBillInstance.hasErrors() && categoryBillInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), categoryBillInstance.id])}"
                redirect(action: "show", id: categoryBillInstance.id)
            }
            else {
                render(view: "edit", model: [categoryBillInstance: categoryBillInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def categoryBillInstance = CategoryBill.get(params.id)
        if (categoryBillInstance) {
            try {
                categoryBillInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'categoryBill.label', default: 'CategoryBill'), params.id])}"
            redirect(action: "list")
        }
    }
}
