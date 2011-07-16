package domain
class Bill {

  String name
  Float balance
  Currency currency
  Boolean isHidden
  Boolean isChecked
  String color
  static belongsTo = [ category:Category ]
  static hasMany = [operations: Operation]
  static constraints = {
    name()
    isChecked(blank: false)
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
