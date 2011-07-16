package services

import domain.auth.SecUser
import domain.*

class CategoryService {
  def springSecurityService
  static transactional = true

  def parseEntityOData(def bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: 'o' + bill.id, type: 'opr', chkd: bill.isChecked, color: bill.category.color])
    data.add(inn)
    data
  }

  def parseEntityBData(def bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: 'b' + bill.id, type: 'bil', chkd: bill.isChecked, color: bill.category.color])
    data.add(inn)
    data
  }

  def getCategoryTree() {
    def data = []
    SecUser user = springSecurityService.getCurrentUser()
    user.categoriesB?.each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: 'c' + c.id, type: 'ctb', chkd: c.isChecked, color: c.color])
      def childs = []
      c.bills.each {bill ->
        childs.add(parseEntityBData(bill))
      }
      inn.put('children', childs)
      data.add(inn)
    }
    user.categoriesO?.each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
      def childs = []
      c.operations.each {operation ->
        childs.add(parseEntityOData(operation))
      }
      inn.put('children', childs)
      data.add(inn)
    }
    data
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
      ctg.isChecked = !ctg.isChecked
      ctg.bills.each { bill ->
        bill.isChecked = ctg.isChecked
      }
    }
    else if (params.type == 'cto') {
      def ctg = CategoryOp.findById(params.id[1..-1])
      ctg.isChecked = !ctg.isChecked
      ctg.operations.each { bill ->
        bill.isChecked = ctg.isChecked
      }
    }
  }


  def usersSelectedBillsIds() {
    def billsIds = []
    def user = springSecurityService.getCurrentUser()
    user.categoriesB?.each {c ->
      c.bills.each { bill ->
        if (bill.isChecked) {
          billsIds.add(bill.id)
        }
      }
    }
    billsIds
  }

  def usersSelectedOpsIds() {
    def opsIds = []
    def user = springSecurityService.getCurrentUser()
    user.categoriesO?.each {c ->
      c.operations.each { bill ->
        if (bill.isChecked) {
          opsIds.add(bill.id)
        }
      }
    }
    opsIds
  }

  def initRegisteredUser(def user) {

    //Creating categories
    def ctg1 = new CategoryBill(name: 'Cards', isChecked: true, color: 'red',).save(failOnError: true)
    def ctg2 = new CategoryBill(name: 'Debentures', isChecked: true, color: 'magenta').save(failOnError: true)

    //Creating Bills
    def bill1 = new Bill(name: 'Card1', currency: Currency.findByCode('usd'), balance: 1000, category: ctg1, isChecked: true).save(failOnError: true)
    def bill2 = new Bill(name: 'Note2', currency: Currency.findByCode('eur'), balance: 4040, category: ctg1, isChecked: true).save(failOnError: true)

    ctg1.addToBills(bill1)
    ctg2.addToBills(bill2)

    user.addToCategories(ctg1).addToCategories(ctg2)
  }
}
