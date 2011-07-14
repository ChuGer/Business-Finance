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
  static hasOne = [note : Note]
  static constraints = {
    name(blank: false, unique: true)
    startDate()
    endDate()
    type(inList: [0, 1, 2, 3])

  }
}
