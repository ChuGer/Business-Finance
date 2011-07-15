import domain.auth.SecRole
import domain.auth.SecUser
import domain.auth.SecUserSecRole
import domain.Currency
import domain.Bill
import domain.Operation
import domain.Category

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
              email: 'dus@dus.du',
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
    def ctg1 = new Category(name: 'UleBank').save(failOnError: true)
    def ctg2 = new Category(name: 'BufBank').save(failOnError: true)

    //Creating Bills
    def bill1 = new Bill(name: 'Card1', currency: cur1, balance: 1000, category: ctg1, color: 'red').save(failOnError: true)
    def bill2 = new Bill(name: 'Card2', currency: cur2, balance: 4040, category: ctg1, color: 'magenta').save(failOnError: true)
    def bill3 = new Bill(name: 'iCard', currency: cur2, balance: 4020, category: ctg1, color: 'blue').save(failOnError: true)
    def bill4 = new Bill(name: 'bCard', currency: cur3, balance: 7000, category: ctg1, color: 'black').save(failOnError: true)
    def bill5 = new Bill(name: 'sCard', currency: cur2, balance: 9040, category: ctg2, color: 'green').save(failOnError: true)
    def bill6 = new Bill(name: 'Dep1', currency: cur3, balance: 1040, category: ctg2, color: 'gray').save(failOnError: true)

    //Creating operations
    def op1 = new Operation(name: '���������', type: 2,bill: bill1, startDate: new Date(111,6,7), endDate: new Date(111,6,10)).save(failOnError: true)
    def op2 = new Operation(name: '�������', type: 1,bill: bill2, startDate: new Date(111,6,8), endDate: new Date(111,6,8)).save(failOnError: true)
    def op3 = new Operation(name: '��������', type: 1,bill: bill3, startDate: new Date(111,6,11), endDate: new Date(111,6,12)).save(failOnError: true)
    def op4 = new Operation(name: '���', type: 2,bill: bill3, startDate: new Date(111,6,13), endDate: new Date(111,6,13)).save(failOnError: true)
    def op5 = new Operation(name: '�������', type: 1,bill: bill5, startDate: new Date(111,6,4), endDate: new Date(111,6,5)).save(failOnError: true)

    //Updating categories
    ctg1.addToBills(bill1).addToBills(bill2).addToBills(bill3).addToBills(bill4)
    ctg2.addToBills(bill5).addToBills(bill6)


//    Updating users
    user.addToCategories(ctg1).addToCategories(ctg2)
    user.addToOperations(op1 ).addToOperations(op2 )

    }
  }
  def destroy = {
  }
}
