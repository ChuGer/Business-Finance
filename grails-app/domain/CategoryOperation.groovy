class CategoryOperation extends Base {

  static constraints = {
  }

  static hasMany = [operations: Operation]

}
