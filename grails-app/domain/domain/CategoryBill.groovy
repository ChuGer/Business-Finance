package domain
class CategoryBill {

  String name

  static constraints = {
  }

  static hasMany = [bills: Bill, categories : CategoryBill]

}
