class Operation extends Base {

  Integer type
  Boolean isCommitted
  Bill billFrom
  Bill billTo
  CategoryOperation category
  static constraints = {
    type(inList: [0, 1, 2, 3])
  }


}
