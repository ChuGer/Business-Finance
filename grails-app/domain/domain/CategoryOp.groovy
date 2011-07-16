package domain

import domain.auth.SecUser

class CategoryOp {

  String name
  static hasMany = [operations: Operation, categories: CategoryOp]
  String color
  Boolean isChecked
  static belongsTo = [category: CategoryOp, user: SecUser]
  static constraints = {
    name()
  }
}
