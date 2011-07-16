package domain

import domain.auth.SecUser

class CategoryBill {

  String name
  static hasMany = [bills: Bill, categories: CategoryBill]
  String color
  Boolean isChecked
  static belongsTo = [category: CategoryBill,user :  SecUser]
  static constraints = {
    name()
    bills()
  }

}
