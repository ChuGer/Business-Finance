package domain
class Note {

  String name
  String value
  Boolean isMade = false
  Date endDate
  Boolean isImportant  = false

  static constraints = {
    name()
    value(maxSize: 1000)
    endDate( nullable: true)
  }

  public String toString() {
    "${name}"
  }
}
