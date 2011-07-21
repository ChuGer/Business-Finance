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

  def index = {
    SecUser user = springSecurityService.getCurrentUser();
    [user : user]
  }
}
