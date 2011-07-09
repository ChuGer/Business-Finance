package domain

class Settings {

  String name
  Currency mainCurrency
  Workspace workspace
  static hasMany = [ currenccategories : Currency]
  static constraints = {
  }

}
