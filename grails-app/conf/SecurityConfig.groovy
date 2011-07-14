security {
    active = true
    loginUserDomainClass = "domain.SecUser"
    authorityDomainClass = "domain.auth.SecRole"
    requestMapClass = "domain.auth.SecUserSecRole"

  loginFormUrl = "/"
  defaultTargetUrl = "/note/list"     //TODO:  page after login redirecting to

}
