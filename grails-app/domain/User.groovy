class User extends Base {

  String surname
  String password
  String email
  Settings settings
  static constraints = {
    email(email: true)
    password(password: true)
  }

  static hasMany = [notes: Note, bills: Bill, categories: ICategory, operations: Operation]

}
