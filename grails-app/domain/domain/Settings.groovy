package domain

class Settings {

  User user
  Currency currency
  String language
  String dateFormat
  static constraints = {
    language(inList: ['ru_RU','en_US'])
    dateFormat(inList: ['dd/MM/yy','MM/dd/yy'])
  }

}
