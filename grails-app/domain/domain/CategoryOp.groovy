package domain

class CategoryOp {

  String name
  String ico = 'ctoDef.png'
  static hasMany = [operations: Operation, categories: CategoryOp]
  String color
  Boolean isChecked
  static belongsTo = [category: CategoryOp]
  static constraints = {
    name()
  }

  public String toString() {
    "${name}"
  }
}
