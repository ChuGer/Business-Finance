package services

import domain.*

class CategoryService {
  def springSecurityService
  static transactional = true

  def parseEntityData(Bill bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: bill.id, type: 'bill', chkd: bill.isChecked, color : bill.color])
    data.add(inn)
    data
  }

  def getCategoryTree() {
    def data = []
    def user = springSecurityService.getCurrentUser()
    user.categories?.each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: 'c'+c.id, type: 'ctgr', chkd: c.isChecked])
      def childs = []
      c.bills.each {bill ->
        childs.add(parseEntityData(bill))
      }
      inn.put('children', childs)
      data.add(inn)
    }
    data
  }

  def persistCheckEvent(def params) {
    if (params.type == 'bill') {
      def bill = Bill.findById(params.id)
      bill.isChecked = !bill.isChecked
    }
    else {
      def ctg = Category.findById(params.id)
      ctg.isChecked = !ctg.isChecked
      ctg.bills.each { bill ->
        bill.isChecked = ctg.isChecked
      }
    }
  }
  def getUsersSelectedBills(){
    def bills = []
     def user = springSecurityService.getCurrentUser()
    user.categories?.each {c ->
      c.bills.each { bill ->
        if ( bill.isChecked) {
          bills.add(bill)
        }
      }
    }
    bills
  }

  def initRegisteredUser(def user){

     //Creating categories
    def ctg1 = new Category(name: 'Cards', isChecked: true).save(failOnError: true)
    def ctg2 = new Category(name: 'Debentures', isChecked: true).save(failOnError: true)

      //Creating Bills
    def bill1 = new Bill(name: 'Card1', currency: Currency.findByCode('usd'), balance: 1000, category: ctg1, color: 'red', isChecked: true).save(failOnError: true)
    def bill2 = new Bill(name: 'Note2', currency: Currency.findByCode('eur'), balance: 4040, category: ctg1, color: 'magenta', isChecked: true).save(failOnError: true)

    ctg1.addToBills(bill1)
    ctg2.addToBills(bill2)

    user.addToCategories(ctg1).addToCategories(ctg2)
  }
}
