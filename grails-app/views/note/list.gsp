<%@ page import="domain.Note" %>
<html>
<head>
  %{--<g:javascript library="jquery" plugin="jquery"/>--}%
  %{--<script type="text/javascript" src="../js/jquery/jquery-1.4.2.js"></script>--}%
  %{--<script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>--}%
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'note.label', default: 'Note')}"/>
  <g:javascript library="jquery" plugin="jquery"/>
  <jsTree:resources/>

  <script type="text/javascript">
    $(document).ready(function() {


      $('#hh').click(function() {
        $("#demo1").jstree("check_all");
        $.getJSON("${createLink(controller:'notes',action:'zub')}", {gender:'Male', ajax: 'true'},
                 function(tdata) {
                   var myHTMLString = ''
                   for (var i = 0; i < tdata.length; i++) {
                     myHTMLString = myHTMLString + '<tr><td>' + tdata[i].type + '</td>'
                     myHTMLString = myHTMLString + '<td>' + tdata[i].name + '</td>'
                     myHTMLString = myHTMLString + '<td>' + tdata[i].data + '</td></tr>'
                   }
                   $('table#mytable').html(myHTMLString)
                 })
      })

      var treeData = $.parseJSON('${treeData}');
      $('#demo1').jstree({

        "json_data" : {
          "data" : [
            treeData
          ]
        },
        "plugins" : [ "themes", "checkbox", "json_data", "ui" ,"contextmenu","crrm"]
      }).bind("check_node.jstree",
             function (e, d) {
               var sname = $("#demo1").jstree('get_text', '#' + d.rslt.obj.attr("id"));
               var sid = d.rslt.obj.attr("id")
               alert(sid + "  " + sname);
               jQuery.ajax({
                 url: 'treeCheck',
                 type: "POST",
                 data: {name: sname, id: sid },
                 dataType: "json"
               });
             }).bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      })
              .bind("create.jstree",
                   function(event, data) {
                     alert(data.rslt.obj.attr("id") + "  " + $("#demo1").jstree('get_text', '#' + d.rslt.obj.attr("id")));
                   }).bind("select_node.jstree",
                          function (e, d) {
                            alert(d.rslt.obj.attr("id") + " id  clicked  " + $("#demo1").jstree('get_text', '#' + d.rslt.obj.attr("id")));
                          });


//             $("#demo1").jstree("get_checked", false, true).each(function(index,element){alert($(element).attr("id"));});

//        $.jstree._reference('#demo1').refresh();
//     var tree = $.jstree._reference('#demo1');
//             tree.uncheck_all() ;
//            alert('Handler for .click() called.');
//});


    });

  </script>

  <export:resource/>

</head>
<body>
<div id="demo1"></div>


<div id="hh">=[=====click=======]=</div>
<div id="hh2">=[=====puck=======]=</div>
<table id="mytable"></table>
<div class="nav">
  <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
  <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]"/></g:link></span>
</div>
<div class="body">
  <h1><g:message code="default.list.label" args="[entityName]"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="list">
    <table>
      <thead>
      <tr>

        <g:sortableColumn property="id" title="${message(code: 'note.id.label', default: 'Id')}"/>

        <g:sortableColumn property="value" title="${message(code: 'note.value.label', default: 'Value')}"/>

        <g:sortableColumn property="name" title="${message(code: 'note.name.label', default: 'Name')}"/>

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
    <g:paginate total="${noteInstanceTotal}"/>
  </div>
  <export:formats/>
</div>
</body>
</html>
