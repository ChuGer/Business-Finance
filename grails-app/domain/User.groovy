class User extends Base {

  String password
  String email
  Settings settings
  static constraints = {
    email(email: true)
    password(password: true)
  }

  static hasMany = [notes: Note, bills: Bill, categories: Category, operations: Operation]

}
