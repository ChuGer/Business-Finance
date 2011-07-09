import Currency

class CurrencyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [currencyInstanceList: Currency.list(params), currencyInstanceTotal: Currency.count()]
    }

    def create = {
        def currencyInstance = new Currency()
        currencyInstance.properties = params
        return [currencyInstance: currencyInstance]
    }

    def save = {
        def currencyInstance = new Currency(params)
        if (currencyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'currency.label', default: 'Currency'), currencyInstance.id])}"
            redirect(action: "show", id: currencyInstance.id)
        }
        else {
            render(view: "create", model: [currencyInstance: currencyInstance])
        }
    }

    def show = {
        def currencyInstance = Currency.get(params.id)
        if (!currencyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
            redirect(action: "list")
        }
        else {
            [currencyInstance: currencyInstance]
        }
    }

    def edit = {
        def currencyInstance = Currency.get(params.id)
        if (!currencyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [currencyInstance: currencyInstance]
        }
    }

    def update = {
        def currencyInstance = Currency.get(params.id)
        if (currencyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (currencyInstance.version > version) {
                    
                    currencyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'currency.label', default: 'Currency')] as Object[], "Another user has updated this Currency while you were editing")
                    render(view: "edit", model: [currencyInstance: currencyInstance])
                    return
                }
            }
            currencyInstance.properties = params
            if (!currencyInstance.hasErrors() && currencyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'currency.label', default: 'Currency'), currencyInstance.id])}"
                redirect(action: "show", id: currencyInstance.id)
            }
            else {
                render(view: "edit", model: [currencyInstance: currencyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def currencyInstance = Currency.get(params.id)
        if (currencyInstance) {
            try {
                currencyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'currency.label', default: 'Currency'), params.id])}"
            redirect(action: "list")
        }
    }
}
