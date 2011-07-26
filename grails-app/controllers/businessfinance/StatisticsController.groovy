package businessfinance

import domain.auth.SecUser
import domain.LoginStat

class StatisticsController {
  static navigation = [
          group: 'tabs',
          order: 7,
          title: "statistics",
          action: 'index'
  ]
  def springSecurityService

  def index = {
    SecUser user = springSecurityService.getCurrentUser()
    if (user != null) {
      [logins: LoginStat.list(params) ]
    }
  }
}
