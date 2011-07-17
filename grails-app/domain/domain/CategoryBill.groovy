package domain

class CategoryBill {

  String name
  static hasMany = [bills: Bill, categories: CategoryBill]
  String color
  Boolean isChecked
  static belongsTo = [category: CategoryBill ]
  static constraints = {
    name()
    bills()
  }
  public String toString() {
    "${name}"
  }

}
