package domain

import domain.auth.SecUser

class Operation {
  static belongsTo = [ category:CategoryOp, user : SecUser ]
  String name
  Long period
  Long times
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
    name(blank: false, unique: true)
    isRepeatable(nullable: true)
    isCommitted(nullable: true)
    note(nullable: true)
    period(nullable: true)
    times(nullable: true)
    startDate(nullable: false)
    endDate(nullable: true)
    type(inList: [0, 1])
  }
  public String toString(){
    "${name} ${startDate}-${endDate}"
  }
}
