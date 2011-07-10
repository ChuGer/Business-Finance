import domain.auth.Authority
import domain.User
import domain.auth.PersonAuthority

class BootStrap {

    def springSecurityService
    def init = { servletContext ->
        if(!Person.count()){
        def userRole = new Authority(authority: 'ROLE_USER' ).save(failOnError: true)
        def password = springSecurityService.encodePassword('123')

        [jeff: 'Jef Beown', donald: 'Donald Ducks']
        def user = new User(username: 'qwe',realname: 'Bob',password: password,enabled: true).save(failOnError: true)
        def user2 = new User(username: 'asd',realname: 'Frog',password: password,enabled: true).save(failOnError: true)
        PersonAuthority.create user, userRole, true
        PersonAuthority.create user2, userRole, true
        }
    }
    def destroy = {
    }
}
