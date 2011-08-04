package services

import org.springframework.context.i18n.LocaleContextHolder as LCH

import domain.Bill
import domain.CategoryBill
import domain.CategoryOp
import domain.Operation
import domain.auth.SecUser

class FetchService {

  def springSecurityService
  def messageSource
  static transactional = true
//  static scope = "session"        TODO uncomment on release 8)

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
    inn.put('attr', [id: 'b' + bill.id, type: 'bil', chkd: bill.isChecked, color: bill.category.color, class: 'jstree-checked'])
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

  def parsePureCtgOData(def ctg) {
    def data = []
    ctg.categories?.each {c ->
      def inn = [:]
      inn.put('data', [title: c.name, icon: '../images/treei/' + c.ico])
      inn.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
      def childs = []
      c.categories?.each {cti ->
        def inn2 = [:]
        inn2.put('data', [title: cti.name, icon: '../images/treei/' + cti.ico])
        inn2.put('attr', [id: 'd' + cti.id, type: 'cto', chkd: cti.isChecked, color: cti.color])
        def childs2 = parsePureCtgOData(cti)
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

  def getBillTree() {
    def data = []
    SecUser user = springSecurityService.getCurrentUser()
    if (!user)
      return data
    def c = user.categoriesB
    def inn = [:]
    inn.put('data', [title: messageSource.getMessage('tree.title.rootBill', null, LCH.getLocale()), icon: '../images/treei/' + c.ico])
    inn.put('attr', [id: 'c' + c.id, type: 'ctb', chkd: c.isChecked, color: c.color])
    def childs = parseCtgBData(c)
    inn.put('children', childs)
    data.add(inn)
    data
  }

  def getCategoryTree() {
    def data = []
    SecUser user = springSecurityService.getCurrentUser()
    if (!user)
      return data
    def c = user.categoriesB
    def inn = [:]
    inn.put('data', [title: messageSource.getMessage('tree.title.rootBill', null, LCH.getLocale()), icon: '../images/treei/' + c.ico])
    inn.put('attr', [id: 'c' + c.id, type: 'ctb', chkd: c.isChecked, color: c.color])
    def childs = parseCtgBData(c)
    inn.put('children', childs)
    data.add(inn)

    c = user.categoriesO
    def inn2 = [:]
    inn2.put('data', [title: messageSource.getMessage('tree.title.rootOp', null, LCH.getLocale()), icon: '../images/treei/' + c.ico])
    inn2.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
    def childs2 = parseCtgOData(c)
    inn2.put('children', childs2)
    data.add(inn2)
    data
  }

  def getPureCategoryOpTree() {
    def data = []
    SecUser user = springSecurityService.getCurrentUser()
    if (!user)
      return data

    def c = user.categoriesO
    def inn2 = [:]
    inn2.put('data', [title: messageSource.getMessage('tree.title.rootOp', null, LCH.getLocale()), icon: '../images/treei/' + c.ico])
    inn2.put('attr', [id: 'd' + c.id, type: 'cto', chkd: c.isChecked, color: c.color])
    def childs = parsePureCtgOData(c)
    inn2.put('children', childs)
    data.add(inn2)
    data
  }


  def usersSelectedBillsIds() {
    Operation.executeQuery("select id from Bill where user = :user and isChecked = true",
            [user: springSecurityService.getCurrentUser()])
  }

  def usersSelectedOpsIds() {
    Operation.executeQuery("select id from Operation where user = :user and isChecked = true",
            [user: springSecurityService.getCurrentUser()])
  }

  def parseBillById(def id) {
    def list = [[id: id]]
    def bill = Bill.findById(id)
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'b' + bill.id, type: 'bil', chkd: bill.isChecked, color: bill.category.color])
    inn.put('metadata', [id: bill.id])
    data.add(inn)
    list.add(data)
    list
  }

  def parseCtgBillById(def id) {
    def list = [[id: id]]
    def bill = CategoryBill.findById(id)
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'c' + bill.id, type: 'ctb', chkd: bill.isChecked, color: bill.color])
    inn.put('metadata', [id: bill.id])
    inn.put('children', [])
    data.add(inn)
    list.add(data)
    list
  }

  def parseOperById(def id) {
    def list = [[id: id]]
    def bill = Operation.findById(id)
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'o' + bill.id, type: 'opr', chkd: bill.isChecked, color: bill.category.color])
    inn.put('metadata', [id: bill.id])
    data.add(inn)
    list.add(data)
    list
  }

  def parseCtgOperById(def id) {
    def list = [[id: id]]
    def bill = CategoryOp.findById(id)
    def data = []
    def inn = [:]
    inn.put('data', [title: bill.name, icon: '../images/treei/' + bill.ico])
    inn.put('attr', [id: 'd' + bill.id, type: 'cto', chkd: bill.isChecked, color: bill.color])
    inn.put('metadata', [id: bill.id])
    inn.put('children', [])
    data.add(inn)
    list.add(data)
    list
  }


}
