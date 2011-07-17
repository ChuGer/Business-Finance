package services

import domain.auth.SecUser
import domain.*

class CategoryService {
  def springSecurityService
  static transactional = true

  def parseEntityOData(def bill) {
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'o' + bill.id, type: 'opr', chkd: bill.isChecked, color: bill.category.color])
    inn.put('metadata', [id: bill.id])
    data.add(inn)
    data
  }

  def parseEntityBData(def bill) {
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'b' + bill.id, type: 'bil', chkd: bill.isChecked, color: bill.category.color])
    data.add(inn)
    data
  }

  def parseCtgOData(def ctg) {
    def data = []
    ctg.operations?.each {bill ->
      def dataE = parseEntityOData(bill)
      data.add(dataE)
    }

    ctg.categories?.each {c ->
      def inn = [:]
      inn.put('data', [title: c.name, icon: '../images/treei/' + c.ico])
      inn.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
      def childs = []
      c.operations?.each {bill ->
        def child = parseEntityOData(bill)
        childs.add(child)
      }
      c.categories?.each {cti ->
        def inn2 = [:]
        inn2.put('data', [title: cti.name, icon: '../images/treei/' + cti.ico])
        inn2.put('attr', [id: 'd' + cti.id, type: 'cto', chkd: cti.isChecked, color: cti.color])
        def childs2 = parseCtgOData(cti)
        inn2.put('children', childs2)
        childs.add(inn2)
      }
      inn.put('children', childs)
      data.add(inn)

    }
    data
  }

  def parseCtgBData(def ctg) {
    def data = []
    ctg.bills?.each {bill ->
      def dataE = parseEntityBData(bill)
      data.add(dataE)
    }

    ctg.categories?.each {c ->
      def inn = [:]
      inn.put('data', [title: c.name, icon: '../images/treei/' + c.ico])
      inn.put('attr', [id: 'c' + c.id, type: 'ctb', chkd: c.isChecked, color: c.color])
      def childs = []
      c.bills?.each {bill ->
        def child = parseEntityBData(bill)
        childs.add(child)
      }
      c.categories?.each {cti ->
        def inn2 = [:]
        inn2.put('data', [title: cti.name, icon: '../images/treei/' + cti.ico])
        inn2.put('attr', [id: 'c' + cti.id, type: 'ctb', chkd: cti.isChecked, color: cti.color])
        def childs2 = parseCtgBData(cti)
        inn2.put('children', childs2)
        childs.add(inn2)
      }
      inn.put('children', childs)
      data.add(inn)

    }
    data
  }

  def getCategoryTree() {
    def data = []
    SecUser user = springSecurityService.getCurrentUser()
    if (!user)
      return data
    def c = user.categoriesB
    def inn = [:]
    inn.put('data', [title: c.name, icon: '../images/treei/' + c.ico])
    inn.put('attr', [id: 'c' + c.id, type: 'ctb', chkd: c.isChecked, color: c.color])
    def childs = parseCtgBData(c)
    inn.put('children', childs)
    data.add(inn)

    c = user.categoriesO
    def inn2 = [:]
    inn2.put('data', [title: c.name, icon: '../images/treei/' + c.ico])
    inn2.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
    def childs2 = parseCtgOData(c)
    inn2.put('children', childs2)
    data.add(inn2)
    data
  }

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


  def usersSelectedBillsIds() {
    def billsIds = []
    SecUser user = springSecurityService.getCurrentUser()
    List<Bill> bills = Bill.findAllByUserAndIsChecked(user, true)
    bills.each { b ->    billsIds.add(b.id)}
    billsIds
  }

  def usersSelectedOpsIds() {
    def opsIds = []
    SecUser user = springSecurityService.getCurrentUser()
    List<Operation> ops = Operation.findAllByUserAndIsChecked(user, true)
    ops.each { o ->    opsIds.add(o.id)}
    opsIds
  }

  def initRegisteredUser(def user) {
    // TODO inject from bootsra4
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
