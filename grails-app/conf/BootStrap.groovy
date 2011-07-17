import domain.auth.SecRole
import domain.auth.SecUser
import domain.auth.SecUserSecRole
import domain.*

class BootStrap {

  def springSecurityService
  def init = { servletContext ->
    // Creating users
    if (!SecUser.count()) {
      def userRole = new SecRole(authority: 'ROLE_USER').save(failOnError: true)
      def adminRole = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)
      def password = springSecurityService.encodePassword('123')

      def adminUser = SecUser.findByUsername('admin') ?: new SecUser(
              username: 'admin',
              surname: 'Bob',
              realname: 'Bob',
              email: 'admin@admin.com',
              password: springSecurityService.encodePassword('admin'),
              enabled: true).save(failOnError: true)

      if (!adminUser.authorities.contains(adminRole)) {
        SecUserSecRole.create adminUser, adminRole
      }

      def user = new SecUser(username: 'qwe', surname: 'Zohan', realname: 'Bob', email: 'dus@dusca.du', password: password, enabled: true).save(failOnError: true)
      def user2 = new SecUser(username: 'asd', surname: 'Bob', realname: 'Frog', email: 'dus@dus.su', password: password, enabled: true).save(failOnError: true)
      SecUserSecRole.create user, userRole, true
      SecUserSecRole.create user2, userRole, true

      //Creating Curencies
      def cur1 = new Currency(code: 'rur', name: 'curencies.rur').save(failOnError: true)
      def cur2 = new Currency(code: 'usd', name: 'curencies.usd').save(failOnError: true)
      def cur3 = new Currency(code: 'eur', name: 'curencies.eur').save(failOnError: true)

      //Creating categories
      def rootB = new CategoryBill(name: 'root.bill', isChecked: true, color: 'magenta', ico: 'smiley-mr-green.png').save(failOnError: true)

      def rootO = new CategoryOp(name: 'root.oper', isChecked: true, color: 'magenta', ico: 'script-office.png').save(failOnError: true)

      def ctg1 = new CategoryBill(name: 'UleBank', isChecked: true, color: 'blue').save(failOnError: true)
      def ctg2 = new CategoryBill(name: 'BufBank', isChecked: true, color: 'magenta').save(failOnError: true)
      def ctg3 = new CategoryBill(name: 'subBu', isChecked: true, color: 'magenta').save(failOnError: true)

      def ctg6 = new CategoryOp(name: 'Bo2l', isChecked: true, color: 'magenta').save(failOnError: true)
      def ctg7 = new CategoryOp(name: 'Pay2', isChecked: true, color: 'red').save(failOnError: true)

      //Creating Bills
      def bill1 = new Bill(name: 'Card1', currency: cur1, balance: 1000, category: ctg1, isChecked: true, user : user, ico: 'user.png').save(failOnError: true)
      def bill2 = new Bill(name: 'Card2', currency: cur2, balance: 4040, category: ctg1, isChecked: true, user : user).save(failOnError: true)
      def bill3 = new Bill(name: 'iCard', currency: cur2, balance: 4020, category: ctg1, isChecked: true, user : user).save(failOnError: true)
      def bill4 = new Bill(name: 'bCard', currency: cur3, balance: 7000, category: ctg1, isChecked: true, user : user).save(failOnError: true)
      def bill5 = new Bill(name: 'sCard', currency: cur2, balance: 9040, category: ctg1, isChecked: true, user : user).save(failOnError: true)
      def bill6 = new Bill(name: 'Dep1', currency: cur3, balance: 1040, category: ctg1, isChecked: true, user : user).save(failOnError: true)
      def bill7 = new Bill(name: 'Dep2', currency: cur1, balance:  40, category: ctg1, isChecked: true, user : user).save(failOnError: true)

      //Creating operations
      def op1 = new Operation(name: 'Колбасы', user: user, category: ctg7, type: 0, bill: bill1, startDate: new Date(111, 6, 7), endDate: new Date(111, 6, 10)).save(failOnError: true)
      def op2 = new Operation(name: 'Вертолёт', user: user, category: ctg7, type: 1, bill: bill2, startDate: new Date(111, 6, 8), endDate: new Date(111, 6, 8)).save(failOnError: true)
      def op3 = new Operation(name: 'Car', user: user, category: ctg7, type: 1, bill: bill3, startDate: new Date(111, 6, 11), endDate: new Date(111, 6, 12), ico: 'hand-point.png').save(failOnError: true)
      def op4 = new Operation(name: 'bear', user: user, category: ctg7, type: 0, bill: bill3, startDate: new Date(111, 6, 13), endDate: new Date(111, 6, 13)).save(failOnError: true)
      def op5 = new Operation(name: 'dog house', user: user, category: ctg7, type: 1, bill: bill5, startDate: new Date(111, 6, 4), endDate: new Date(111, 6, 5)).save(failOnError: true)

      //Updating categories
      ctg1.addToBills(bill1).addToBills(bill2).addToBills(bill3)
      ctg2.addToBills(bill5).addToBills(bill6)
      ctg3.addToBills(bill4).addToBills(bill7)

      ctg6.addToOperations(op1).addToOperations(op2).addToOperations(op3)
      ctg7.addToOperations(op4).addToOperations(op5)

//    Updating users
      user.categoriesB = rootB
      user.categoriesO = rootO
      ctg1.addToCategories(ctg3)
      rootB.addToCategories(ctg2).addToCategories(ctg1)
      rootO.addToCategories(ctg6).addToCategories(ctg7)
      user.addToOperations(op1).addToOperations(op2).addToOperations(op3).addToOperations(op5).addToOperations(op5)

    }
  }
  def destroy = {
  }
}
