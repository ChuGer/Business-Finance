class CategoryBill extends ICategory {

  static constraints = {
  }

  static hasMany = [bills: Bill]

}
