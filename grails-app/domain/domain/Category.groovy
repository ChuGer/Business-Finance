package domain
class Category {

  String name

  static constraints = {
    name()
    bills()
  }

  static hasMany = [bills: Bill]

}
