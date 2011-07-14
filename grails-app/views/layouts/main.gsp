<!DOCTYPE html>
<html>
<head>
  <title><g:layoutTitle default="Grails"/></title>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
  <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
  <g:layoutHead/>
  <nav:resources/>
  <g:javascript library="application"/>
</head>
<body>
<div id="spinner" class="spinner" style="display:none;">
  <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt="${message(code: 'spinner.alt', default: 'Loading...')}"/>
</div>
<br/>

<div id="menu">
  <div style="width: 500px; float: left;">
    <nav:render group="tabs"/>
  </div>
  <div style="position: relative; float: right; margin:10px 0px;">
    <sec:ifNotLoggedIn>
      <g:link controller="login" action="auth">[=Login=]</g:link>
    </sec:ifNotLoggedIn>
    <sec:ifAllGranted roles="ROLE_USER">
      <h2><sec:username/></h2>  <g:link controller="logout">[=Logout=]</g:link>
    </sec:ifAllGranted>
  </div>
</div>
<div style="margin-top:50px;">
  <g:layoutBody/>
</div>
</body>
</html>