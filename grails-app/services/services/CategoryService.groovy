package services

import domain.*

class CategoryService {
  def springSecurityService
  static transactional = true

  def parseEntityData(Bill bill) {
    def data = []
    def inn = [:]
    inn.put('data', bill.name)
    inn.put('attr', [id: bill.id, type: 'bill', chkd: bill.isChecked])
    data.add(inn)
    data
  }

  def getCategoryTree() {
    def data = []
    def user = springSecurityService.getCurrentUser()
    user.categories?.each {c ->
      def inn = [:]
      inn.put('data', c.name)
      inn.put('attr', [id: c.id, type: 'ctgr', chkd: c.isChecked])
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
    println params.name + ' with id ' + params.id + ' is ' + params.type
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
}
