

<%@ page import="domain.CategoryOperation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'categoryOperation.label', default: 'CategoryOperation')}" />
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
            <g:hasErrors bean="${categoryOperationInstance}">
            <div class="errors">
                <g:renderErrors bean="${categoryOperationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${categoryOperationInstance?.id}" />
                <g:hiddenField name="version" value="${categoryOperationInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="categories"><g:message code="categoryOperation.categories.label" default="Categories" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: categoryOperationInstance, field: 'categories', 'errors')}">
                                    <g:select name="categories" from="${domain.CategoryOperation.list()}" multiple="yes" optionKey="id" size="5" value="${categoryOperationInstance?.categories*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="categoryOperation.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: categoryOperationInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${categoryOperationInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="operations"><g:message code="categoryOperation.operations.label" default="Operations" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: categoryOperationInstance, field: 'operations', 'errors')}">
                                    
<ul>
<g:each in="${categoryOperationInstance?.operations?}" var="o">
    <li><g:link controller="operation" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="operation" action="create" params="['categoryOperation.id': categoryOperationInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'operation.label', default: 'Operation')])}</g:link>

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
