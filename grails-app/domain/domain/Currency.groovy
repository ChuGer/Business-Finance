package domain
class Currency {

  String name
  String code

  static constraints = {
    name()
    code()
  }

  public String toString() {
    "${name} ${code}"
  }
}
