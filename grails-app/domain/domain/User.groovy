package domain

import domain.auth.SecUser


class User extends SecUser {

  Settings settings
  static hasMany = [
          categories: Category,
          operations: Operation
  ]

  static constraints = {
    settings nullable: true
  }


}
