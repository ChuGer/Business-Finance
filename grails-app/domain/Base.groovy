class Base {

    Long id
    Long version
    Date created
    String name
    String comment
    String iconPath

    static constraints = {
      iconPath(blank: true)
    }
}
