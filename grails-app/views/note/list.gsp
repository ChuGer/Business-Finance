
<%@ page import="domain.Note" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'note.label', default: 'Note')}" />
      <g:javascript library="jquery" plugin="jquery"/>
<jsTree:resources />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
    <script type="text/javascript">
      $(function () {
          // TO CREATE AN INSTANCE
          // select the tree container using jQuery
          $("#demo1")
              // call `.jstree` with the options object
              .jstree({
                  // the `plugins` array allows you to configure the active plugins on this instance
                  "plugins" : ["themes","html_data","ui","crrm","hotkeys"],
                  // each plugin you have included can have its own config object
                  "core" : { "initially_open" : [ "phtml_1" ] }
                  // it makes sense to configure a plugin only if overriding the defaults
              })
              // EVENTS
              // each instance triggers its own events - to process those listen on the container
              // all events are in the `.jstree` namespace
              // so listen for `function_name`.`jstree` - you can function names from the docs
              .bind("loaded.jstree", function (event, data) {
                  // you get two params - event & data - check the core docs for a detailed description
              });
          // INSTANCES
          // 1) you can call most functions just by selecting the container and calling `.jstree("func",`
          setTimeout(function () { $("#demo1").jstree("set_focus"); }, 500);
          // with the methods below you can call even private functions (prefixed with `_`)
          // 2) you can get the focused instance using `$.jstree._focused()`.
          setTimeout(function () { $.jstree._focused().select_node("#phtml_1"); }, 1000);
          // 3) you can use $.jstree._reference - just pass the container, a node inside it, or a selector
          setTimeout(function () { $.jstree._reference("#phtml_1").close_node("#phtml_1"); }, 1500);
          // 4) when you are working with an event you can use a shortcut
          $("#demo1").bind("open_node.jstree", function (e, data) {
              // data.inst is the instance which triggered this event
              data.inst.select_node("#phtml_2", true);
          });
          setTimeout(function () { $.jstree._reference("#phtml_1").open_node("#phtml_1"); }, 2500);
      });

      </script>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'note.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="value" title="${message(code: 'note.value.label', default: 'Value')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'note.name.label', default: 'Name')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${noteInstanceList}" status="i" var="noteInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${noteInstance.id}">${fieldValue(bean: noteInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: noteInstance, field: "value")}</td>
                        
                            <td>${fieldValue(bean: noteInstance, field: "name")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${noteInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
