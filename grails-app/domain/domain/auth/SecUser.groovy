package domain.auth

class SecUser {

  String username
  String realname
  String password
  boolean enabled
  boolean accountExpired
  boolean accountLocked
  boolean passwordExpired
  String email

  static constraints = {
    username blank: false, unique: true
    password blank: false
    email nullable: true
    realname nullable: true
    password(password: true)
//    email(email: true)
  }
  static searchable = [only: 'realname']
  static mapping = {
    password column: '`password`'
  }

  Set<SecRole> getAuthorities() {
    SecUserSecRole.findAllBySecUser(this).collect { it.secRole } as Set
  }
}
