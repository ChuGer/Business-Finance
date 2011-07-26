package businessfinance

import domain.LoginStat
import domain.auth.SecUser

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
    params.max = params.max ?: 10
    if (user != null) {
      [logins: LoginStat.list(params) ]
    }
  }
}
