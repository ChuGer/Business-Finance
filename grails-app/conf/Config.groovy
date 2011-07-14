// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [html: ['text/html', 'application/xhtml+xml'],
        xml: ['text/xml', 'application/xml'],
        text: 'text/plain',
        js: 'text/javascript',
        rss: 'application/rss+xml',
        atom: 'application/atom+xml',
        css: 'text/css',
        csv: 'text/csv',
        pdf: 'application/pdf',
        rtf: 'application/rtf',
        excel: 'application/vnd.ms-excel',
        ods: 'application/vnd.oasis.opendocument.spreadsheet',
        all: '*/*',
        json: ['application/json', 'text/json'],
        form: 'application/x-www-form-urlencoded',
        multipartForm: 'multipart/form-data'
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'
// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable for AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// set per-environment serverURL stem for creating absolute links
environments {
  production {
    grails.serverURL = "http://www.changeme.com"
  }
  development {
    grails.serverURL = "http://localhost:8080/${appName}"
  }
  test {
    grails.serverURL = "http://localhost:8080/${appName}"
  }

}

// log4j configuration
log4j = {
  // Example of changing the log pattern for the default console
  // appender:
  //
  //appenders {
  //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
  //}

  error 'org.codehaus.groovy.grails.web.servlet',  //  controllers
          'org.codehaus.groovy.grails.web.pages', //  GSP
          'org.codehaus.groovy.grails.web.sitemesh', //  layouts
          'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
          'org.codehaus.groovy.grails.web.mapping', // URL mapping
          'org.codehaus.groovy.grails.commons', // core / classloading
          'org.codehaus.groovy.grails.plugins', // plugins
          'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
          'org.springframework',
          'org.hibernate',
          'net.sf.ehcache.hibernate'

  warn 'org.mortbay.log'
}
// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.password.algorithm = 'SHA-512'
grails.plugins.springsecurity.userLookup.userDomainClassName = 'domain.auth.SecUser'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'domain.auth.SecUserSecRole'
grails.plugins.springsecurity.authority.className = 'domain.auth.SecRole'

grails.plugins.springsecurity.securityConfigType = grails.plugins.springsecurity.SecurityConfigType.InterceptUrlMap
grails.plugins.springsecurity.interceptUrlMap = [         //TODO == map all  pages!====
        '/plugins/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
//    '/*/**':         ['ROLE_USER','IS_AUTHENTICATED_FULLY'],
        '/Note/**': ['ROLE_USER', 'IS_AUTHENTICATED_FULLY'],
        '/Operation/**': ['ROLE_USER', 'IS_AUTHENTICATED_FULLY'],
        '/login/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/logout/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/js/**': ['IS_AUTHENTICATED_ANONYMOUSLY']
]
grails.plugins.springsecurity.secureChannel.definition = [
        '/**': 'REQUIRES_SECURE_CHANNEL'
]

//Mail settings
//grails.plugins.springsecurity.ui.register.postRegisterUrl = '/welcome'
grails.plugins.springsecurity.ui.register.defaultRoleNames = ['ROLE_USER  ']
grails.plugins.springsecurity.ui.register.emailBody = 'Greetings, ${user.username}! Please, click <a  href="${url}">here</a> to ocmplite your registration process'
grails.plugins.springsecurity.ui.register.emailFrom = 'altortik@gmail.com'
grails.plugins.springsecurity.ui.register.emailSubject = 'BFApplication registration'

grails.plugins.springsecurity.ui.forgotPassword.emailBody = 'Greetings, ${user.username}! You have requested your  password to be reset. If you did that request, click <a  href="${url}">here </a> to reset your password'
grails.plugins.springsecurity.ui.forgotPassword.emailFrom = 'altortik@gmail.com'
grails.plugins.springsecurity.ui.forgotPassword.emailSubject = 'BFApplication password recovery'

grails {
  mail {
    host = "smtp.gmail.com"
    port = 465
    username = "altortik@gmail.com"
    password = "gugeliza"
    props = ["mail.smtp.auth": "true",
            "mail.smtp.socketFactory.port": "465",
            "mail.smtp.socketFactory.class": "javax.net.ssl.SSLSocketFactory",
            "mail.smtp.socketFactory.fallback": "false"]

  }
}
