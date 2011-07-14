<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.main.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <jsTree:resources/>
  <script type="text/javascript">
    var treeComponent =  $("#treeDiv");
    $(function() {
      var treeData = $.parseJSON('${treeData}');

      var tree = treeComponent.jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "checkbox", "json_data", "ui" ,"contextmenu","crrm"]
      });

      tree.bind("check_node.jstree", function (e, d) {
        var sname = treeComponent.jstree('get_text', '#' + d.rslt.obj.attr("id"));
        var sid = d.rslt.obj.attr("id")
        alert(sid + "  " + sname);
        jQuery.ajax({
          url: 'treeCheck',
          type: "POST",
          data: {name: sname, id: sid },
          dataType: "json"
        });
      });
      tree.bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      });
      tree.bind("create.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + treeComponent.jstree('get_text', '#' + d.rslt.obj.attr("id")));
      });
      tree.bind("select_node.jstree", function (e, d) {
        alert(d.rslt.obj.attr("id") + " id  clicked  " + treeComponent.jstree('get_text', '#' + d.rslt.obj.attr("id")));
      });

      function selectAll() {
        treeComponent.jstree("check_all");
      };
    });

  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.main.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <div id="treeDiv"></div>
  <button id="selectAll" onclick="selectAll();">selectAll</button>
</div>
</body>
</html>

