<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.note.title"/></title>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.note.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
</div>
</body>
</html>

