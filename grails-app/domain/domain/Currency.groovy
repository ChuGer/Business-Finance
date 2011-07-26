package domain
class Currency {
  static auditable = true

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
