<!DOCTYPE html>
<html>
<head>
  <title><g:layoutTitle default="Grails"/></title>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
  <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
  <g:layoutHead/>
  <nav:resources/>
  <g:javascript library="application"/>
  %{--<jq:resources></jq:resources>--}%
</head>
<body>
<div id="spinner" class="spinner" style="display:none;">
  <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt="${message(code: 'spinner.alt', default: 'Loading...')}"/>
</div>
<div id="grailsLogo"><a href="http://grails.org"><img src="${resource(dir: 'images', file: 'grails_logo.png')}" alt="Grails" border="0"/></a>
  <br/> <sec:ifNotLoggedIn>
  <g:link controller="login" action="auth">[=Login=]</g:link>
</sec:ifNotLoggedIn>
<sec:ifAllGranted roles="ROLE_USER">
  <h2>user : "<sec:username/>"</h2>  <g:link controller="logout">[=Logout=]</g:link>
</sec:ifAllGranted>
  <div id="menu">
		<nav:render group="tabs"/>
  </div>

</div>


<g:layoutBody/>
</body>
</html>