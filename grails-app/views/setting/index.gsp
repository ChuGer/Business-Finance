<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.setting.title"/></title>
  <style type="text/css">
  #settingsTable tbody tr:hover {
    background: none repeat scroll 0 0 #D0DAFD;
    color: #333399;
  }

  #settingsTable tbody tr td {
    padding: 7px;
  }
  </style>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.setting.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:form method="post">
    <g:hiddenField name="id" value="${settingsInstance?.id}"/>
    <g:hiddenField name="version" value="${settingsInstance?.version}"/>
    <table id="settingsTable">
      <tr>
        <td style="min-width:150px;"><h3><g:message code="user.username"/></h3></td>
        <td>${user.username}</td>
      </tr>
      <tr>
        <td><h3><g:message code="user.name"/></h3></td>
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

      <tr class="prop">
        <td valign="top" class="name">
          <h3><label for="language"><g:message code="settings.language.label" default="Language"/></label></h3>
        </td>
        <td valign="top" class="value ${hasErrors(bean: settingsInstance, field: 'language', 'errors')}">
          <g:select name="language" from="${settingsInstance.constraints.language.inList}" value="${settingsInstance?.language}" valueMessagePrefix="settings.language"/>
        </td>
      </tr>

      <tr class="prop">
        <td valign="top" class="name">
          <h3><label for="dateFormat"><g:message code="settings.dateFormat.label" default="Date Format"/></label></h3>
        </td>
        <td valign="top" class="value ${hasErrors(bean: settingsInstance, field: 'dateFormat', 'errors')}">
          <g:select name="dateFormat" from="${settingsInstance.constraints.dateFormat.inList}" value="${settingsInstance?.dateFormat}" valueMessagePrefix="settings.dateFormat"/>
        </td>
      </tr>

      <tr class="prop">
        <td valign="top" class="name">
          <h3><label for="currency.id"><g:message code="settings.currency.label" default="Currency"/></label></h3>
        </td>
        <td valign="top" class="value ${hasErrors(bean: settingsInstance, field: 'currency', 'errors')}">
          <g:select name="currency.id" from="${domain.Currency.list()}" optionKey="id" value="${settingsInstance?.currency?.id}" noSelection="['null': '']"/>
        </td>
      </tr>
    </table>

    <div class="buttons">
      <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}"/></span>
    </div>
  </g:form>
</div>
</body>
</html>

