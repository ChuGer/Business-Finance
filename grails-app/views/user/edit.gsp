

<%@ page import="domain.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${userInstance}">
            <div class="errors">
                <g:renderErrors bean="${userInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${userInstance?.id}" />
                <g:hiddenField name="version" value="${userInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="email"><g:message code="user.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${userInstance?.email}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="password"><g:message code="user.password.label" default="Password" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'password', 'errors')}">
                                    <g:passwordField name="password" value="${userInstance?.password}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="billCategories"><g:message code="user.billCategories.label" default="Bill Categories" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'billCategories', 'errors')}">
                                    <g:select name="billCategories" from="${domain.CategoryBill.list()}" multiple="yes" optionKey="id" size="5" value="${userInstance?.billCategories*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="bills"><g:message code="user.bills.label" default="Bills" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'bills', 'errors')}">
                                    <g:select name="bills" from="${domain.Bill.list()}" multiple="yes" optionKey="id" size="5" value="${userInstance?.bills*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="user.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${userInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="notes"><g:message code="user.notes.label" default="Notes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'notes', 'errors')}">
                                    <g:select name="notes" from="${domain.Note.list()}" multiple="yes" optionKey="id" size="5" value="${userInstance?.notes*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="operationCategories"><g:message code="user.operationCategories.label" default="Operation Categories" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'operationCategories', 'errors')}">
                                    <g:select name="operationCategories" from="${domain.CategoryOperation.list()}" multiple="yes" optionKey="id" size="5" value="${userInstance?.operationCategories*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="operations"><g:message code="user.operations.label" default="Operations" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'operations', 'errors')}">
                                    <g:select name="operations" from="${domain.Operation.list()}" multiple="yes" optionKey="id" size="5" value="${userInstance?.operations*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="settings"><g:message code="user.settings.label" default="Settings" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'settings', 'errors')}">
                                    <g:select name="settings.id" from="${domain.Settings.list()}" optionKey="id" value="${userInstance?.settings?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="surname"><g:message code="user.surname.label" default="Surname" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: userInstance, field: 'surname', 'errors')}">
                                    <g:textField name="surname" value="${userInstance?.surname}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
