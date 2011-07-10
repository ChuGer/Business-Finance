package domain

import domain.auth.PersonAuthority
import domain.auth.Authority

class User {
  String realname
  String username
  String password
  String email
  boolean enabled
  boolean accountExpired
  boolean accountLocked
  boolean passwordExpired
  Settings settings
  static hasMany = [notes: Note,
          bills: Bill,
          billCategories: CategoryBill,
          operationCategories: CategoryOperation,
          operations: Operation]
  static searchable = [only: 'realname']
  static mapping = {
    password column: '`password`'
  }

  static constraints = {
    username blank: false, unique: true
    password blank: false
    email(email: true)
    password(password: true)
  }


  Set<Authority> getAuthorities() {
    PersonAuthority.findAllByPerson(this).collect { it.authority } as Set
  }


}
