class Note extends Base{

    String value

    static constraints = {
      value(maxSize: 10000)
    }
}
