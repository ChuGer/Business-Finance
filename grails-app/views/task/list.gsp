

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'task.label', default: 'Task')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'task.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="iconPath" title="${message(code: 'task.iconPath.label', default: 'Icon Path')}" />
                        
                            <g:sortableColumn property="notifyType" title="${message(code: 'task.notifyType.label', default: 'Notify Type')}" />
                        
                            <g:sortableColumn property="comment" title="${message(code: 'task.comment.label', default: 'Comment')}" />
                        
                            <g:sortableColumn property="created" title="${message(code: 'task.created.label', default: 'Created')}" />
                        
                            <g:sortableColumn property="endDate" title="${message(code: 'task.endDate.label', default: 'End Date')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${taskInstanceList}" status="i" var="taskInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${taskInstance.id}">${fieldValue(bean: taskInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: taskInstance, field: "iconPath")}</td>
                        
                            <td>${fieldValue(bean: taskInstance, field: "notifyType")}</td>
                        
                            <td>${fieldValue(bean: taskInstance, field: "comment")}</td>
                        
                            <td><g:formatDate date="${taskInstance.created}" /></td>
                        
                            <td><g:formatDate date="${taskInstance.endDate}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${taskInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
