package domain
class Note {
  static auditable = true

  String name
  String value
  Boolean isMade = false
  Date endDate
  Boolean isImportant  = false
  static belongsTo = [ category:CategoryNote]

  static constraints = {
    name()
    value(maxSize: 1000)
    endDate( nullable: true)
    category( nullable: true)
  }

  public String toString() {
    "${name}"
  }
}
