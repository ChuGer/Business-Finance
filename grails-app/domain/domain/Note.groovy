package domain
class Note {

    String name
    String value
    Operation operation
    static constraints = {
      name()
      value(maxSize: 10000)
      operation(nullable: true)
    }
}
