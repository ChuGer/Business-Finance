package businessfinance

import domain.auth.SecUser

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
    [user : user]
  }
}
