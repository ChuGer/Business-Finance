package domain
class Bill {

  String name
  Float balance
  Currency currency
  Boolean isHidden
  Boolean isChecked
  static belongsTo = [category: CategoryBill]
  static hasMany = [operations: Operation]
  static constraints = {
    name()
    isChecked(blank: false)
    balance()
    currency()
    isHidden(nullable: true)
    category()
    operations()
  }

  public String toString() {
    if (!currency.isAttached())
      currency.attach()
    "${name} (${currency?.code})"
  }
}
