package businessfinance

import domain.LoginStat
import org.grails.plugin.filterpane.FilterPaneUtils

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
    def user = springSecurityService.getCurrentUser()
    if (user) {
      defaultParams()
      if (user != null) {
        [logins: LoginStat.findAllBySettings(user.settings, params)]
      }
    }
  }

  def defaultParams() {
    params.max = params.max ?: 20
    params.sort = params.sort ?: 'date'
    params.order = params.order ?: 'desc'
//    params.put('filter.settings.user.idTo',null)
//    params.put('filter.settings.user.id',2)
//    params.put('filter.op.settings.user.id','Equal')
  }

  def filter = {
    def user = springSecurityService.getCurrentUser()
    if (user) {
      defaultParams()
      //TODO: remove crooked nail
      def stats = filterPaneService.filter(params, LoginStat)
      stats.removeAll {st ->
        st.settings.user.id != user.id
      }
      render(view: 'index',
              model: [
                      logins: stats,
                      count: stats.size(),
                      filterParams: FilterPaneUtils.extractFilterParams(params),
                      params: params
              ])
    }
  }

}
