package domain

class CategoryNote {
  static auditable = true

  String name
  static hasMany = [notes: Note]
  static constraints = {
  }

  public String toString() {
    "${name}"
  }
}
