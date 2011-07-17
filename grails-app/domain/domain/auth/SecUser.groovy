package domain.auth

import domain.Bill
import domain.Operation
import domain.Settings

class SecUser {
  String username
  String realname
  String surname
  String password
  boolean enabled
  boolean accountExpired
  boolean accountLocked
  boolean passwordExpired
  String email
  Settings settings
  domain.CategoryBill categoriesB
  domain.CategoryOp  categoriesO
  static hasMany =
  [       bills: Bill,
          operations: Operation
  ]
  static constraints = {
    username blank: false, unique: true
    realname nullable: true
    surname nullable: true
    password blank: false
    email blank: false
    password(password: true)
    email(email: true)
    settings nullable: true
    categoriesB nullable: true
    categoriesO nullable: true
  }
//  static searchable = [only: 'realname']     //Searchable Plugin
  static mapping = {
    password column: '`password`'
  }

  Set<SecRole> getAuthorities() {
    SecUserSecRole.findAllBySecUser(this).collect { it.secRole } as Set
  }
}
