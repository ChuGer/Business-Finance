package domain

import domain.auth.SecUser

class Settings {

  static belongsTo = [user : SecUser]
  Currency currency
  String language
  String dateFormat
  static constraints = {
    language(inList: ['ru_RU','en_US'])
    dateFormat(inList: ['dd/MM/yy','MM/dd/yy'])
  }

}
