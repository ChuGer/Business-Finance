package businessfinance


class MainController {
  static navigation = [
          group: 'tabs',
          order: 1,
          title: "main",
          action: 'index'
  ]
  def userService

  def index = {
    userService.saveUserInfo(this.class.simpleName)
  }

}
