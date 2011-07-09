
<%@ page import="domain.Currency" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'currency.label', default: 'Currency')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'currency.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="code" title="${message(code: 'currency.code.label', default: 'Code')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${currencyInstanceList}" status="i" var="currencyInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${currencyInstance.id}">${fieldValue(bean: currencyInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: currencyInstance, field: "code")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${currencyInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
