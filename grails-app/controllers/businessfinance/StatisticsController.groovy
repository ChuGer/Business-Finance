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
  def filterPaneService

  def index = {
    SecUser user = springSecurityService.getCurrentUser()
    params.max = params.max ?: 10
    if (user != null) {
      [logins: LoginStat.list(params)]
    }
  }

  def filter = {
    if (!params.max) params.max = 10
    render(view: 'index',
            model: [
                    logins: filterPaneService.filter(params, LoginStat),
                    count: filterPaneService.count(params, LoginStat),
                    filterParams: org.grails.plugin.filterpane.FilterPaneUtils.extractFilterParams(params),
                    params: params
            ])
  }
}
