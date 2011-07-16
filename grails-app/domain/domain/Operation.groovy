package domain
class Operation {

  String name
  Long period
  Long times
  Date startDate
  Date endDate
  Integer type
  Boolean isRepietable
  Boolean isCommitted
  Bill bill
  Note note
  static hasOne = Note
  static constraints = {
    name(blank: false, unique: true)
    isRepietable(nullable: true)
    isCommitted(nullable: true)
    note(nullable: true)
    period(nullable: true)
    times(nullable: true)
    startDate(nullable: false)
    endDate(nullable: true)
    type(inList: [0, 1, 2, 3])
  }
  public String toString(){
    "${id} ${name} ${startDate} ${endDate}"
  }
}
