package domain
class User {

  String name
  String surname
  String password
  String email
  Settings settings
  static constraints = {
    email(email: true)
    password(password: true)
  }

  static hasMany = [
          notes: Note,
          bills: Bill,
          billCategories: CategoryBill,
          operationCategories: CategoryOperation,
          operations: Operation
  ]
}
