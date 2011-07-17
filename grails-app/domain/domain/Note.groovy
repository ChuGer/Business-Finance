package domain
class Note {

  String name
  String value
  static belongsTo = [operation: Operation]
  static constraints = {
    name()
    value(maxSize: 10000)
    operation(nullable: true)
  }

  public String toString() {
    "${name}"
  }
}
