

<%@ page import="domain.Operation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'operation.label', default: 'Operation')}" />
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
            <g:hasErrors bean="${operationInstance}">
            <div class="errors">
                <g:renderErrors bean="${operationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${operationInstance?.id}" />
                <g:hiddenField name="version" value="${operationInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="type"><g:message code="operation.type.label" default="Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'type', 'errors')}">
                                    <g:select name="type" from="${operationInstance.constraints.type.inList}" value="${fieldValue(bean: operationInstance, field: 'type')}" valueMessagePrefix="operation.type"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="billFrom"><g:message code="operation.billFrom.label" default="Bill From" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'billFrom', 'errors')}">
                                    <g:select name="billFrom.id" from="${domain.Bill.list()}" optionKey="id" value="${operationInstance?.billFrom?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="billTo"><g:message code="operation.billTo.label" default="Bill To" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'billTo', 'errors')}">
                                    <g:select name="billTo.id" from="${domain.Bill.list()}" optionKey="id" value="${operationInstance?.billTo?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="category"><g:message code="operation.category.label" default="Category" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'category', 'errors')}">
                                    <g:select name="category.id" from="${domain.CategoryOperation.list()}" optionKey="id" value="${operationInstance?.category?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="isCommitted"><g:message code="operation.isCommitted.label" default="Is Committed" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'isCommitted', 'errors')}">
                                    <g:checkBox name="isCommitted" value="${operationInstance?.isCommitted}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="operation.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${operationInstance?.name}" />
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
