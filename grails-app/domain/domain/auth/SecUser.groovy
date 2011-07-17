package domain.auth

import domain.Operation
import domain.Settings
import domain.CategoryBill
import domain.CategoryOp

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
  CategoryBill categoriesB
  CategoryOp categoriesO
  static hasMany =
  [
          operations: Operation
  ]
  static constraints = {
    username blank: false, unique: true
    realname nullable: true
    surname nullable: true
    password blank: false
    email(blank: false,email: true)
    password(password: true)
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

  public String toString() {
    "${username} (${realname} ${surname})}"
  }
}
