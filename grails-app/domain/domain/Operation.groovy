package domain

import domain.auth.SecUser

class Operation {
  static auditable = true
  static belongsTo = [category: CategoryOp, user: SecUser]
  String name
  String ico = 'oprDef.png'
  Long period
  Long times
  Float sum
  Date startDate
  Boolean isChecked = true
  Integer type
  Boolean isRepeatable
  Boolean isCommitted
  Bill bill
  static hasOne = Note
  static constraints = {
    name(blank: false, unique: false)
    bill()
    sum(blank: false)
    type()
    startDate(nullable: false)
    isRepeatable(nullable: true)
    isCommitted(nullable: true)
    period(nullable: true)
    times(nullable: true)
  }

  public String toString() {
    "${name} ${startDate}"
  }
//
//  def onSave = {
//    println "operation inserted"
//    // may optionally refer to newState map
//  }
//  def onDelete = {
//    println "operation was deleted"
//  }
//  def onChange = { oldMap, newMap ->
//    println "operation was changed ..."
//    oldMap.each({ key, oldVal ->
//      if (oldVal != newMap[key]) {
//        println " * $key changed from $oldVal to " + newMap[key]
//      }
//    })
//  }
}
