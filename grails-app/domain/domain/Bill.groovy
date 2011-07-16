package domain
class Bill {

  String name
  Float balance
  Currency currency
  Boolean isHidden
  String color
  Category category
  static belongsTo = Category
  static hasMany = [operations: Operation]
  static constraints = {
    name()
    balance()
    currency()
    color(nullable: true)
    isHidden(nullable: true)
    category()
    operations()
  }
  public String toString() {
    "${name} (${currency?.code})"
  }
}
