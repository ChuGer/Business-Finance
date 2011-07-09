package domain
class Note {

    String name
    String value

    static constraints = {
      value(maxSize: 10000)
    }
}
