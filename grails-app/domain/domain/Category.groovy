package domain
class Category {

  String name

  static hasMany = [bills: Bill]

  static constraints = {
    name()
    bills()
  }

}
