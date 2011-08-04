package services

import domain.Bill
import domain.CategoryBill
import domain.CategoryOp
import domain.Operation

class PersistService {

  static transactional = true
//  static scope = "session"        TODO uncomment on release 8)

  def checkCtgB(CategoryBill ctg) {
    ctg.bills?.each { bill ->
      bill.isChecked = bill.category.isChecked
    }
    ctg.categories?.each { bill ->
      bill.isChecked = bill.category.isChecked
      checkCtgB(bill)
    }
  }

  def checkCtgO(CategoryOp ctg) {
    ctg.operations.each { bill ->
      bill.isChecked = ctg.isChecked
    }
    ctg.categories.each { bill ->
      bill.isChecked = bill.category.isChecked
      checkCtgO(bill)
    }
  }

  def persistCheckEvent(def params) {

    if (params.type == 'bil') {
      def bill = Bill.findById(params.id[1..-1])
      bill.isChecked = !bill.isChecked
    }
    else if (params.type == 'opr') {
      def bill = Operation.findById(params.id[1..-1])
      bill.isChecked = !bill.isChecked
    }
    else if (params.type == 'ctb') {
      def ctg = CategoryBill.findById(params.id[1..-1])
      boolean checked = params.ch == '1' ?: false
      ctg.isChecked = checked
      checkCtgB(ctg)
    }
    else if (params.type == 'cto') {
      def ctg = CategoryOp.findById(params.id[1..-1])
      boolean checked = params.ch == '1' ?: false
      ctg.isChecked = checked
      checkCtgO(ctg)
    }
  }

  private def ctgReflect(def ctb) {
    def data = []
    ctb.bills.each { b ->
      Operation.findAllByBill(b).each {op ->
        op.isChecked = b.isChecked
        data.add(op.id)
      }
    }
    ctb.categories.each { c ->
      data = data + ctgReflect(c)
    }
    data
  }

  def reflectedOpBillCkeck(def type, def id) {
    def data = []
//    if (type == 'bil' || type == 'ctb')
//      return data
    if (type == 'bil') {
      def bill = Bill.findById(id)
      Operation.findAllByBill(bill).each {op ->
        data.add(op.id)
        op.isChecked = bill.isChecked
      }
    }
    else if (type == 'ctb') {
      def ctb = CategoryBill.findById(id)
      data = data + ctgReflect(ctb)
    }
//    print data
    data
  }

  def initRegisteredUser(def user) {
    // TODO inject from bootsra4
    //Creating categories
    def rootB = new CategoryBill(name: 'Bills', isChecked: true, color: 'lime', ico: 'smiley-mr-green.png').save(failOnError: true)
    def rootO = new CategoryOp(name: 'Operations', isChecked: true, color: 'magenta', ico: 'script-office.png').save(failOnError: true)
    user.categoriesB = rootB
    user.categoriesO = rootO
  }
}
