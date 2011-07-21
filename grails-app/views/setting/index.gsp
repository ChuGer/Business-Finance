<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.setting.title"/></title>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.setting.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table>
    <tr>
      <td><h3><g:message code="user.username"/></h3> </td>
      <td>${user.username}</td>
    </tr>
    <tr>
      <td><h3><g:message code="user.name"/></h3> </td>
      <td>${user.realname}</td>
    </tr>
    <tr>
      <td><h3><g:message code="user.surname"/></h3></td>
      <td>${user.surname}</td>
    </tr>
    <tr>
      <td><h3><g:message code="user.email"/></h3></td>
      <td>${user.email}</td>
    </tr>
  </table>
</div>
</body>
</html>

