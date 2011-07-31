package services

import org.springframework.web.context.request.RequestContextHolder as RCH

import domain.Browser
import domain.LoginStat
import domain.auth.SecUser

class UserService {

  static transactional = false
  static scope = "session"
  def springSecurityService
  public final static String CHROME = "chrome"
  public final static String FIREFOX = "firefox"
  public final static String SAFARI = "safari"
  public final static String OTHER = "other"
  public final static String OPERA = "opera"
  public final static String MSIE = "msie"
  public final static String BLACKBERRY = "blackberry"
  public final static String SEAMONKEY = "seamonkey"

//  public final static SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss")

  def saveUserInfo(className) {
    SecUser user = springSecurityService.getCurrentUser()
    if (user != null) {
      def agentInfo = getUserAgentInfo()
      def browser = Browser.findByNameAndVers(agentInfo.name, agentInfo.vers)
      if (browser == null) {
        browser = new Browser(name: agentInfo.name, vers: agentInfo.vers)
        if (!browser.save()) {
          browser.errors.each { e ->
            println e
          }
        }
      }
      def login = new LoginStat(date: new Date(), browser: browser, page: className.toLowerCase().replaceAll('controller', ''), ip:agentInfo.ip);
      login.settings = user.settings
      if (!login.save()) {
        login.errors.each { e ->
          println e
        }
      }
    }
  }

  def getRequest() {
    return RCH.currentRequestAttributes().currentRequest
  }

  def getSession() {
    return RCH.currentRequestAttributes().session
  }

  def getUserAgentInfo() {
    def userAgent = getRequest().getHeader("user-agent")

    def agentInfo = [:]
    def vers = null
    def ip = getRequest().getRemoteAddr()
    def name

    if (userAgent == null) {
      agentInfo.vers = null
      agentInfo.name = OTHER
      return agentInfo
    }

    name = OTHER;

    int pos = -1;
    if ((pos = userAgent.indexOf("Firefox")) >= 0) {
      name = FIREFOX;
      vers = userAgent.substring(pos + 8).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));
    }
    if ((pos = userAgent.indexOf("Opera")) >= 0) {
      name = OPERA
      vers = userAgent.substring(pos + 6).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));
    }
    if ((pos = userAgent.indexOf("Chrome")) >= 0) {
      name = CHROME;
      vers = userAgent.substring(pos + 7).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("Safari")) >= 0 && (userAgent.indexOf("Chrome") == -1)) {
      name = SAFARI;
      vers = userAgent.substring(pos + 7).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("BlackBerry")) >= 0) {
      name = BLACKBERRY;
      vers = userAgent.substring(userAgent.indexOf("/")).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("SeaMonkey")) >= 0) {
      name = SEAMONKEY;
      vers = userAgent.substring(userAgent.indexOf("/")).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("MSIE")) >= 0) {
      name = MSIE;
      vers = userAgent.substring(pos + 5).trim();
      if (vers.indexOf(" ") > 0)
        vers = vers.substring(0, vers.indexOf(" "));
      if (vers.indexOf(";") > 0)
        vers = vers.substring(0, vers.indexOf(";"));

    }

    agentInfo.vers = vers
    agentInfo.name = name
    agentInfo.ip = ip

    return agentInfo
  }
}
