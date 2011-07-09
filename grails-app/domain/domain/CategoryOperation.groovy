package domain
class CategoryOperation {

  String name

  static constraints = {
  }

  static hasMany = [operations: Operation, categories : CategoryOperation]

}
