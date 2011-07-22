<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.operation.title"/></title>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.operation.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table>
    <tr>
      <th><h2><g:message code="operation.name.label"/></h2></th>
      <th><h2><g:message code="operation.sum.label"/></h2></th>
      <th><h2><g:message code="operation.startDate.label"/></h2></th>
    </tr>
    <g:each in="${rootCat.categories}" var="i">
      <tr>
        <th style="background: ${i.color}; color: white;">
          <h3>${i.name}</h3>
        </th>
      </tr>
      <g:each in="${i.operations}" var="io">
        <tr>
          <td>${io.name}</td>
          <td>${io.sum}</td>
          <td><g:formatDate date="${io.startDate}" format="dd/MM/yyyy"/></td>
        </tr>
      </g:each>
      <g:each in="${i.categories}" var="ic">
        <tr>
          <th style="background: ${ic.color}; color: white;"><g:message code="all.space.formatter"/>${ic.name}</th>
        </tr>
        <g:each in="${i.operations}" var="ioi">
          <tr>
            <td><g:message code="all.space.formatter"/>${ioi.name}</td>
            <td>${ioi.sum}</td>
            <td>${ioi.startDate.dateString}</td>
          </tr>
        </g:each>
      </g:each>
    </g:each>
  </table>

</div>
</body>
</html>

