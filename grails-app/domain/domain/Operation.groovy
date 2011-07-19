package domain

import domain.auth.SecUser

class Operation {
  static belongsTo = [category: CategoryOp, user: SecUser]
  String name
  String ico = 'oprDef.png'
  Long period
  Long times
  Float sum
  Date startDate
  Date endDate
  Boolean isChecked = true
  Integer type
  Boolean isRepeatable
  Boolean isCommitted
  Bill bill
  Note note
  static hasOne = Note
  static constraints = {
    name(blank: false, unique: false)
    bill()
    sum(blank: false)
    type()
    startDate(nullable: false)
    endDate(nullable: true)
    note(nullable: true)
    isRepeatable(nullable: true)
    isCommitted(nullable: true)
    period(nullable: true)
    times(nullable: true)
  }

  public String toString() {
    "${name} ${startDate}-${endDate}"
  }
}
