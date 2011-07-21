package domain

class CategoryNote {
  String name
  static hasMany = [notes: Note]
  static constraints = {
  }

  public String toString() {
    "${name}"
  }
}
