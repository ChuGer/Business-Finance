package domain

import domain.auth.SecUser


class User extends SecUser {

  Settings settings
  static hasMany = [notes: Note,
          bills: Bill,
          billCategories: CategoryBill,
          operationCategories: CategoryOperation,
          operations: Operation]

  static constraints = {
    settings nullable: true
  }


}
