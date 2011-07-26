import domain.auth.SecRole
import domain.auth.SecUser
import domain.auth.SecUserSecRole
import domain.*

class BootStrap {

  def springSecurityService
  def messageSource

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
      def cur1 = new Currency(code: 'RUR', name: 'ruble').save(failOnError: true)
      def cur2 = new Currency(code: 'USD', name: 'dollar').save(failOnError: true)
      def cur3 = new Currency(code: 'EUR', name: 'euro').save(failOnError: true)

      //Creating categories
      def rootB = new CategoryBill(name: 'Bills', isChecked: true, color: 'lime', ico: 'smiley-mr-green.png').save(failOnError: true)
      def rootO = new CategoryOp(name: 'Operations', isChecked: true, color: 'magenta', ico: 'script-office.png').save(failOnError: true)

      def ctg1 = new CategoryBill(name: 'Virtual', isChecked: true, color: 'blue').save(failOnError: true)

      def ctg5 = new CategoryOp(name: 'Entertainment', isChecked: true, color: 'gold').save(failOnError: true)
      def ctg6 = new CategoryOp(name: 'Food', isChecked: true, color: 'green').save(failOnError: true)
      def ctg7 = new CategoryOp(name: 'Clothes', isChecked: true, color: 'red').save(failOnError: true)

      def rootN = new CategoryNote(name : 'root')

      //creating notes
      def ctn1 = new  CategoryNote(name : 'Payments')
      def ctn2 = new  CategoryNote(name : 'Loclo')
      def note1 = new Note(name : 'About Artup', endDate : new Date(), value :'text text zozozohnanejn an nwoot tro ginuief gre ., ! g,eGER ', isImportant: true)
      def note2 = new Note(name : 'take corkt', value :'text text zgh  GG /g?$? r1?R GErG ?@4segweweG$ gsd seg, 3 ')
      def note3 = new Note(name : 'Gofe nHio',endDate : new Date() -2, value :'text text zGHD GHERKG EGQG M WG ')
      def note4 = new Note(name : 'Kuziy pes', value :'СЕДьмао поораз атв выдоа волйое ицугоищ ')
      def note5 = new Note(name : 'Alfable ritoniy',endDate : new Date() -3, value :'Серый ронслдиай за жк ипод лвыть , пкуп ,')
      def note6 = new Note(name : 'Duso xiotr jiu', value :'Елзьме бювбтаы д жиао оу и пронос ипгоцук ')
      ctn1.addToNotes(note1).addToNotes(note2)
      ctn2.addToNotes(note3).addToNotes(note4).addToNotes(note5).addToNotes(note6)

      //Creating Bills
      def bill1 = new Bill(name: 'Webmoney', currency: cur2, balance: 1000, category: ctg1, isChecked: true, user: user).save(failOnError: true)
      def bill2 = new Bill(name: 'Visa', currency: cur3, balance: 2000, category: ctg1, isChecked: true, user: user).save(failOnError: true)
      def bill3 = new Bill(name: 'Cash', currency: cur1, balance: 100000, category: rootB, isChecked: true, user: user, ico: 'user.png').save(failOnError: true)

      //Creating operations
      def op1 = new Operation(name: 'Party', sum: 1000, user: user, category: ctg5, type: 0, bill: bill1, startDate: new Date(111, 6, 7)).save(failOnError: true)
      def op2 = new Operation(name: 'Shopping', sum: 2000, user: user, category: ctg7, type: 0, bill: bill2, startDate: new Date(111, 6, 8)).save(failOnError: true)
      def op3 = new Operation(name: 'Car', sum: 5000, user: user, category: ctg5, type: 0, bill: bill3, startDate: new Date(111, 6, 11)).save(failOnError: true)
      def op4 = new Operation(name: 'Thief', sum: 4000, user: user, category: ctg5, type: 1, bill: bill3, startDate: new Date(111, 6, 13)).save(failOnError: true)
      def op5 = new Operation(name: 'Work', sum: 1000, user: user, category: ctg5, type: 1, bill: bill3, startDate: new Date(111, 6, 4)).save(failOnError: true)
      def op6 = new Operation(name: 'Gifts', sum: 1000, user: user, category: ctg7, type: 1, bill: bill1, startDate: new Date(111, 6, 27)).save(failOnError: true)
      def op7 = new Operation(name: 'Rent', sum: 3000, user: user, category: ctg7, type: 1, bill: bill2, startDate: new Date(111, 6, 8)).save(failOnError: true)
      def op8 = new Operation(name: 'Post', sum: 5000, user: user, category: ctg6, type: 0, bill: bill3, startDate: new Date(111, 6, 12)).save(failOnError: true)
      def op9 = new Operation(name: 'Medicine', sum: 4000, user: user, category: ctg6, type: 0, bill: bill3, startDate: new Date(111, 6, 29)).save(failOnError: true)

      //Updating categories
      ctg1.addToBills(bill1).addToBills(bill2)
      rootB.addToBills(bill3)

      ctg5.addToOperations(op1).addToOperations(op3).addToOperations(op4).addToOperations(op5)
      ctg6.addToOperations(op8).addToOperations(op9)
      ctg7.addToOperations(op2).addToOperations(op6).addToOperations(op7)

      //Updating users
      user.categoriesB = rootB
      user.categoriesO = rootO
      rootB.addToCategories(ctg1)
      rootO.addToCategories(ctg5).addToCategories(ctg6).addToCategories(ctg7)
      user.addToOperations(op1).addToOperations(op2).addToOperations(op3).addToOperations(op4).addToOperations(op5)
      user.addToOperations(op6).addToOperations(op7).addToOperations(op8).addToOperations(op9)
      user.addToNotes(ctn1).addToNotes(ctn2)

    }
  }
  def destroy = {
  }
}
