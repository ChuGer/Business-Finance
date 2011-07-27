<%@ page import="domain.LoginStat; java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.statistics.title"/></title>
  <filterpane:includes/>
  <style type="text/css">
  .prevLink {
    background: url("../images/browser/back.png") no-repeat;
     height: 30px;
    display:inline-block; }

  .nextLink {
    background: url("../images/browser/forward.png") no-repeat;
    height: 30px;
    display:inline-block;
  }

  .step {
    margin: 0 0.2em 0 0.1em;
    padding:3px;
    font-size:16px;
  }

  .currentStep {
    background: none repeat scroll 0 0 #7A9BAC;
    color: #FFFFFF;
    font-style: normal;
    font-weight: 400;
    font-size:18px;
    padding:5px;
  }

  input[name="_action_filter"] {
    background: -moz-linear-gradient(90deg, #3570B8, #5E9AE2) repeat scroll 0 0 transparent;
    border: 1px solid #2E63A5;
    text-decoration: none;
    color: white;
    text-shadow: 0 -1px 0 #2E63A5;
    padding:5px;
    display:inline-block;
    border-radius:3px;
    text-align:center;
  }

  input[name="_action_filter"]:hover {
    background: -moz-linear-gradient(90deg, whiteSmoke, #5E9AE2) repeat scroll 0 0 transparent;
  }

  </style>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.statistics.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div>

    <g:paginate
            prev="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
            next="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
            total="${count == null ? LoginStat.count(): count}"
            params="${filterParams}"/>
  </div>
  <div>
    <table>
      <thead>
      <g:sortableColumn property="date" titleKey="settings.date" style="min-width: 200px;" params="${filterParams}"/>
      <g:sortableColumn property="page" titleKey="settings.page" style="min-width: 200px;" params="${filterParams}"/>
      <g:sortableColumn property="ip" titleKey="settings.ip" style="min-width: 200px;" params="${filterParams}"/>
      <g:sortableColumn property="browser.name" titleKey="settings.browser" style="min-width: 200px;" params="${filterParams}"/>
      </thead>
      <tbody>

      <g:each in="${logins}" var="login">
        <tr>
          <td>${new SimpleDateFormat("dd.MM.yyyy HH:mm:ss").format(login.date)}</td>
          <td><g:message code="menu.${login.page}.title" default="${login.page}"/></td>
          <td>${login.ip}</td>
          <td><img src="../images/browser/${login.browser.name}.png"> ${login.browser.name} ${login.browser.vers}</td>
        </tr>
      </g:each>
      </tbody>
    </table>
    <filterpane:filterPane domain="domain.LoginStat"
            filterProperties="${['date','ip','browser']}"
            associatedProperties="browser.name, browser.vers"/>
    <filterpane:filterButton />
  </div>
</div>
</body>
</html>

