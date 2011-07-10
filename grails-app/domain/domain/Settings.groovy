package domain

class Settings {

  String name
  Currency mainCurrency
  static hasMany = [ currencies : Currency]
  static constraints = {
  }

}
