<%@ page import="domain.Operation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'operation.label', default: 'Operation')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'operation.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="type" title="${message(code: 'operation.type.label', default: 'Type')}" />
                        
                            <th><g:message code="operation.billFrom.label" default="Bill From" /></th>
                        
                            <th><g:message code="operation.billTo.label" default="Bill To" /></th>
                        
                            <th><g:message code="operation.category.label" default="Category" /></th>
                        
                            <g:sortableColumn property="isCommitted" title="${message(code: 'operation.isCommitted.label', default: 'Is Committed')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${operationInstanceList}" status="i" var="operationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${operationInstance.id}">${fieldValue(bean: operationInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: operationInstance, field: "type")}</td>
                        
                            <td>${fieldValue(bean: operationInstance, field: "billFrom")}</td>
                        
                            <td>${fieldValue(bean: operationInstance, field: "billTo")}</td>
                        
                            <td>${fieldValue(bean: operationInstance, field: "category")}</td>
                        
                            <td><g:formatBoolean boolean="${operationInstance.isCommitted}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${operationInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
