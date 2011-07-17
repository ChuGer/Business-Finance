<!DOCTYPE html>
<html>
<head>
  <title><g:layoutTitle default="Grails"/></title>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
  <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
  <g:layoutHead/>
  <langs:resources/>
  <nav:resources/>
  <g:javascript library="application"/>
</head>
<body>
<div id="spinner" class="spinner" style="display:none;">
  <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt="${message(code: 'spinner.alt', default: 'Loading...')}"/>
</div>
<br/>

<div id="menu">
  <div style="display:inline-block;">
    <nav:render group="tabs"/>
  </div>
  <div style="display:inline-block; float: right; margin-top:20px;">
  <div style="display:inline-block;">
    <sec:ifNotLoggedIn>
    <g:link controller="login" action="auth"><g:message code="main.login"/> </g:link>
    </sec:ifNotLoggedIn>
    <sec:ifAllGranted roles="ROLE_USER">
      <h2><sec:username/></h2>
      </div>
      <div style="display:inline-block;">
        <g:link controller="logout"><g:message code="main.logout"/></g:link>
      </div>
      <div id="lang" style="display:inline-block;">
        <langs:selector langs="en_US, ru"/>
      </div>
    </sec:ifAllGranted>
  </div>
</div>
<g:layoutBody/>
</body>
</html>