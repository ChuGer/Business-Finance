package domain
class Bill {

  String name
  Float balance
  Currency currency
  Boolean isHidden
  String color
  static belongsTo = [category: Category]
  static hasMany = [operations: Operation]
  static constraints = {
    name()
    balance()
    currency()
    isHidden()
    category()
    operations()
  }
}
