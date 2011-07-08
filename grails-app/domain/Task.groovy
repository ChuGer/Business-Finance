class Task extends Base{

    Integer interval
    Date startDate
    Date endDate
    Integer notifyType
    Operation  operation
    static constraints = {
      notifyType(inList: [1,2,3])
    }

}
