
<%@ page import="domain.Bill" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'bill.label', default: 'Bill')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'bill.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="balance" title="${message(code: 'bill.balance.label', default: 'Balance')}" />
                        
                            <th><g:message code="bill.category.label" default="Category" /></th>
                        
                            <th><g:message code="bill.currency.label" default="Currency" /></th>
                        
                            <g:sortableColumn property="name" title="${message(code: 'bill.name.label', default: 'Name')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${billInstanceList}" status="i" var="billInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${billInstance.id}">${fieldValue(bean: billInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: billInstance, field: "balance")}</td>
                        
                            <td>${fieldValue(bean: billInstance, field: "category")}</td>
                        
                            <td>${fieldValue(bean: billInstance, field: "currency")}</td>
                        
                            <td>${fieldValue(bean: billInstance, field: "name")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${billInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
