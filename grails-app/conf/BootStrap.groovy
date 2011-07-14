import domain.auth.SecRole
import domain.auth.SecUser
import domain.User
import domain.auth.SecUserSecRole

class BootStrap {

    def springSecurityService
    def init = { servletContext ->
        if(!User.count()){
        def userRole = new SecRole(authority: 'ROLE_USER' ).save(failOnError: true)
        def adminRole = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)
        def password = springSecurityService.encodePassword('123')

        def adminUser = SecUser.findByUsername('admin') ?: new SecUser(
                username: 'admin',
                surname: 'Bob',
                realname: 'Bob',
                email:'dus@dus.du',
                password: springSecurityService.encodePassword('admin'),
                enabled: true).save(failOnError: true)

        if (!adminUser.authorities.contains(adminRole)) {
            SecUserSecRole.create adminUser, adminRole
        }

        def user = new SecUser(username: 'qwe',surname: 'Bob', realname: 'Bob',email:'dus@dus.du',password: password,enabled: true).save(failOnError: true)
        def user2 = new SecUser(username: 'asd',surname: 'Bob',realname: 'Frog',email:'dus@dus.su',password: password,enabled: true).save(failOnError: true)
        SecUserSecRole.create user, userRole, true
        SecUserSecRole.create user2, userRole, true
        }
    }
    def destroy = {
    }
}
