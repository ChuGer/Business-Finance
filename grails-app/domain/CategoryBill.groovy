class CategoryBill extends Base {

  static constraints = {
  }

  static hasMany = [bills: Bill]

}
