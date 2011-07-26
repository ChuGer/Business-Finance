package domain

class LoginStat {

  Date date
  Browser browser
  String page
  static belongsTo = [settings : Settings]

  static constraints = {
    settings nullable: true
    page nullable: true
  }
}
