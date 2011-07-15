package domain.auth

import domain.Settings
import domain.Operation

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
  static hasMany = [
          categories: domain.Category,
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
//    operations nullable: true
//    categories nullable: true
  }
//  static searchable = [only: 'realname']     //Searchable Plugin
  static mapping = {
    password column: '`password`'
  }

  Set<SecRole> getAuthorities() {
    SecUserSecRole.findAllBySecUser(this).collect { it.secRole } as Set
  }
}
