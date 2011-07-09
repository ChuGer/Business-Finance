class CategoryOperation extends ICategory {

  static constraints = {
  }

  static hasMany = [operations: Operation]

}
