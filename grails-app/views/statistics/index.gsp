<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.statistics.title"/></title>
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
    <table>
      <thead>
      <g:sortableColumn property="date" titleKey="settings.date" style="min-width: 200px;"/>
      <g:sortableColumn property="page" titleKey="settings.page" style="min-width: 200px;"/>
      <g:sortableColumn property="ip" titleKey="settings.ip" style="min-width: 200px;"/>
      <g:sortableColumn property="browser.name" titleKey="settings.browser" style="min-width: 200px;"/>
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
  </div>
</div>
</body>
</html>

