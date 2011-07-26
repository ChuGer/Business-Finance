package domain

class Browser {

  String name
  String vers

  static constraints = {
    vers(nullable: true)
  }
}
