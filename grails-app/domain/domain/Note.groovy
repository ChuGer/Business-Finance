package domain
class Note {

  String name
  String value
  Boolean isMade
  Date endDate
  Boolean isImportant

  static constraints = {
    name()
    value(maxSize: 1000)
    endDate()
    isImportant()
    isMade()
  }

  public String toString() {
    "${name}"
  }
}
