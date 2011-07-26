package domain

import domain.auth.SecUser

class Settings {
  static auditable = true

  static belongsTo = [user: SecUser]
  static hasMany = [logins: LoginStat]

  Currency currency
  String language = 'ru_RU'
  String dateFormat = 'dd/MM/yy'
  static constraints = {
    language(inList: ['ru_RU', 'en_US'])
    dateFormat(inList: ['dd/MM/yy', 'MM/dd/yy'])
    currency(nullable: true)
  }

  public String toString() {
    user.username
  }

}
