package domain.auth

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

  static constraints = {
    username blank: false, unique: true
    realname blank: false
    surname blank: false
    password blank: false
    email blank: false
    password(password: true)
    email(email: true)
  }
  static searchable = [only: 'realname']
  static mapping = {
    password column: '`password`'
  }

  Set<SecRole> getAuthorities() {
    SecUserSecRole.findAllBySecUser(this).collect { it.secRole } as Set
  }
}
