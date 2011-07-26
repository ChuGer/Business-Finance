package services

import domain.auth.SecUser
import org.springframework.web.context.request.RequestContextHolder as RCH
import java.text.SimpleDateFormat

class UserService {

  static transactional = true
  def springSecurityService
  public final static String CHROME = "chrome"
  public final static String FIREFOX = "firefox"
  public final static String SAFARI = "safari"
  public final static String OTHER = "other"
  public final static String MSIE = "msie"
  public final static String UNKNOWN = "unknown"
  public final static String BLACKBERRY = "blackberry"
  public final static String SEAMONKEY = "seamonkey"

  public final static int CLIENT_CHROME = 0
  public final static int CLIENT_FIREFOX = 1
  public final static int CLIENT_SAFARI = 2
  public final static int CLIENT_OTHER = 3
  public final static int CLIENT_MSIE = 4
  public final static int CLIENT_UNKNOWN = 5
  public final static int CLIENT_BLACKBERRY = 6
  public final static int CLIENT_SEAMONKEY = 7
  public final static String FORMAT = "dd.MM.yyyy hh:mm:ss"
  public final static SimpleDateFormat sdf = new SimpleDateFormat(FORMAT)


  def serviceMethod() {
    SecUser user = springSecurityService.getCurrentUser()
    if (user != null) {
      println sdf.format(new Date()) + ": " + user.username
      getUserAgentInfo()
    }
  }

  def getRequest() {
    return RCH.currentRequestAttributes().currentRequest
  }

  def getSession() {
    return RCH.currentRequestAttributes().session
  }

  def getUserAgentTag() {
    getRequest().getHeader("user-agent")
  }

  def getUserAgentInfo() {
    def userAgent = getUserAgentTag()
    def agentInfo = [:]
    def browserVersion
    def browserType

    if (userAgent == null) {
      agentInfo.browserType = CLIENT_UNKNOWN
      return agentInfo
    }

    browserType = CLIENT_OTHER;

    int pos = -1;
    if ((pos = userAgent.indexOf("Firefox")) >= 0) {
      browserType = CLIENT_FIREFOX;
      browserVersion = userAgent.substring(pos + 8).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));
    }
    if ((pos = userAgent.indexOf("Chrome")) >= 0) {
      browserType = CLIENT_CHROME;
      browserVersion = userAgent.substring(pos + 7).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("Safari")) >= 0 && (userAgent.indexOf("Chrome") == -1)) {
      browserType = CLIENT_SAFARI;
      browserVersion = userAgent.substring(pos + 7).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("BlackBerry")) >= 0) {
      browserType = CLIENT_BLACKBERRY;
      browserVersion = userAgent.substring(userAgent.indexOf("/")).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("SeaMonkey")) >= 0) {
      browserType = CLIENT_SEAMONKEY;
      browserVersion = userAgent.substring(userAgent.indexOf("/")).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));

    }
    if ((pos = userAgent.indexOf("MSIE")) >= 0) {
      browserType = CLIENT_MSIE;
      browserVersion = userAgent.substring(pos + 5).trim();
      if (browserVersion.indexOf(" ") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(" "));
      if (browserVersion.indexOf(";") > 0)
        browserVersion = browserVersion.substring(0, browserVersion.indexOf(";"));

    }

    agentInfo.browserVersion = browserVersion
    agentInfo.browserType = browserType
    agentInfo.agentString = userAgent
    println(agentInfo)
    return agentInfo
  }


  public boolean isChrome() {
    return (getUserAgentInfo().browserType == CLIENT_CHROME);
  }

  public boolean isFirefox() {
    return (getUserAgentInfo().browserType == CLIENT_FIREFOX);
  }

  public boolean isMsie() {
    return (getUserAgentInfo().browserType == CLIENT_MSIE);
  }

  public boolean isOther() {
    return (getUserAgentInfo().browserType == CLIENT_OTHER);
  }

  public boolean isSafari() {
    return (getUserAgentInfo().browserType == CLIENT_SAFARI);
  }

  public boolean isBlackberry() {
    return (getUserAgentInfo().browserType == CLIENT_BLACKBERRY);
  }

  public boolean isSeamonkey() {
    return (getUserAgentInfo().browserType == CLIENT_SEAMONKEY);
  }

  public String getBrowserType() {
    switch (getUserAgentInfo().browserType) {
      case CLIENT_FIREFOX:
        return FIREFOX;
      case CLIENT_CHROME:
        return CHROME;
      case CLIENT_SAFARI:
        return SAFARI;
      case CLIENT_SEAMONKEY:
        return SEAMONKEY;
      case CLIENT_MSIE:
        return MSIE;
      case CLIENT_BLACKBERRY:
        return BLACKBERRY;
      case CLIENT_OTHER:
      case CLIENT_UNKNOWN:
      default:
        return OTHER;
    }
  }
}
