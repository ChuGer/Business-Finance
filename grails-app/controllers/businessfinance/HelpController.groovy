package businessfinance

class HelpController {
  static navigation = [
          group: 'tabs',
          order: 8,
          title: "help",
          action: 'index'
  ]
  def userService

  def index = {
    userService.saveUserInfo(this.class.simpleName)
  }
}
