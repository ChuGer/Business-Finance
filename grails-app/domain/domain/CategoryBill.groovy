package domain

class CategoryBill {

  String name
  String ico = 'ctbDef.png'
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
