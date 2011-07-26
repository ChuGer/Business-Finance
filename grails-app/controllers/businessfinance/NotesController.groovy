package businessfinance

import domain.auth.SecUser

class NotesController {
  def springSecurityService
  static navigation = [
          group: 'tabs',
          order: 5,
          title: 'note',
          action: 'index'
  ]
  def userService
  def index = {
    userService.saveUserInfo(this.class.simpleName)
    def categories = []
    SecUser user = springSecurityService.getCurrentUser();
    if (user)
      categories = user.notes
    [categories: categories]
  }
}