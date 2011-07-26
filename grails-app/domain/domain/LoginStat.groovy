package domain

class LoginStat {

  Date date
  Browser browser
  String page
  String ip

  static belongsTo = [settings: Settings]

  static constraints = {
    settings nullable: true
    page nullable: true
    ip nullable: true
  }
}
