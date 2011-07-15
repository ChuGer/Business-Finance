package domain

import domain.auth.SecUser

class Category {

  String name
  static hasMany = [bills: Bill]
  Boolean isChecked
  static belongsTo = SecUser
  static constraints = {
    name()
    bills()
  }

}
