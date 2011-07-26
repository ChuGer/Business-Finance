package businessfinance

import domain.auth.SecUser
import domain.Settings

class SettingController {
  static navigation = [
          group: 'tabs',
          order: 6,
          title: 'setting',
          action: 'index'
  ]

  def springSecurityService
  def userService

  def index = {
    userService.saveUserInfo(this.class.simpleName)
    SecUser user = springSecurityService.getCurrentUser();
    if (user != null) {
      [user: user, settingsInstance: user.settings]
    }
  }

  def update = {
    def settingsInstance = Settings.get(params.id)
    if (settingsInstance) {
      if (params.version) {
        def version = params.version.toLong()
        if (settingsInstance.version > version) {

          settingsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'settings.label', default: 'Settings')] as Object[], "Another user has updated this Settings while you were editing")
          render(view: "index", model: [settingsInstance: settingsInstance])
          return
        }
      }
      settingsInstance.properties = params
      if (!settingsInstance.hasErrors() && settingsInstance.save(flush: true)) {
        flash.message = "${message(code: 'default.updated.message', args: [message(code: 'settings.label', default: 'Settings'), settingsInstance.id])}"
        redirect(action: "index")
      }
      else {
        render(view: "index", model: [settingsInstance: settingsInstance])
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'settings.label', default: 'Settings'), params.id])}"
      redirect(action: "index")
    }
  }
}
