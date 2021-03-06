<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.report.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="../js/jquery/jquery-1.6.1.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.tabs.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.widget.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.core.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>

  <script type="text/javascript" src="../js/daterangepicker.jQuery.js"></script>
  <link rel="stylesheet" href="../css/ui.daterangepicker.css" type="text/css"/>

  <export:resource/>
  <jsTree:resources/>
  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart'], timeout: 5000});
    google.load('visualization', '1', {packages: ['annotatedtimeline'], timeout: 5000});
  </script>
  <script type="text/javascript">
    $(function() {
      createTree();
      $("#tabs").tabs();
      $('#inputDate').daterangepicker({
        arrows:true,
        onChange: function() {
          dateRangeChange();
        }
      });
    });
    var isLoaded = false;
    function createTree() {
      var treeData = $.parseJSON('${treeData}');
      console.log(treeData);
      var tree = $("#treeDiv").jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "checkbox", "json_data", "ui"  ]
      });

      tree.bind("loaded.jstree", function (event, data) {
        tree.jstree("open_all");
        data.inst.get_container().find('li').each(function(i) {
          //restoring check state
          var cel = $('#' + $(this).attr("id")).children('a');
          cel.css("background-color", $(this).attr("color"));
          cel.css("background", "-moz-linear-gradient(left," + $(this).attr("color") + " 0%, white 70%)");
          if ($(this).attr("chkd") == 'true') {
            data.inst.check_node($(this));
          }
          else {
            data.inst.uncheck_node($(this));
          }


        });
        isLoaded = true;
      });

      tree.bind("check_node.jstree", function (e, d) {
        if (isLoaded) {
          var sname = $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id"));
          var sid = d.rslt.obj.attr("id");
          var stype = d.rslt.obj.attr("type");
          jQuery.ajax({
            url: 'treeCheck',
            type: "POST",
            data: {name: sname, id: sid, type: stype, ch : 1},
            dataType: "json",
            success:function() {
                 drawLineChart();
            }
          });
        }
      });
      tree.bind("uncheck_node.jstree", function (e, d) {
        if (isLoaded) {
          var sname = $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id"));
          var sid = d.rslt.obj.attr("id");
          var stype = d.rslt.obj.attr("type");
          jQuery.ajax({
            url: 'treeCheck',
            type: "POST",
            data: {name: sname, id: sid, type: stype, ch : 0},
            dataType: "json",
            success:function() {
              drawLineChart();
            }
          });
        }
      });

//      tree.bind("select_node.jstree", function (e, d) {
//        var newid = d.rslt.obj.attr("id");
//        if (newid.substr(0, 1) == 'b') {
//          jQuery.ajax({
//            url: 'clickEvent',
//            type: "POST",
//            data: {id: newid},
//            dataType: "json",
//            complete: function(data) {
//              $('#statForm').html(data.responseText);
//            }
//          }
//                  );
//        }
//      });
    }


    function drawVisualization() {
      drawLineChart();
      drawPieChart();
    }

    function drawLineChart() {
      // Parse JSON string to JSON object
      $.getJSON("lineChart", function(jsonData) {
        var dataTable = createDataTableFromJSON(jsonData);
        new google.visualization.AnnotatedTimeLine(document.getElementById('lineChart'))
                .draw(dataTable, {displayAnnotations: true, colors: ['red', 'green']});
      })
    }

    function drawPieChart() {
      $.getJSON("pieChart", function(jsonData) {
        var dataTable = new google.visualization.DataTable(jsonData.data, 0.6);

        // Create and draw the visualization.
        var pie = new google.visualization.PieChart(document.getElementById('pieChart'));
        pie.draw(dataTable, {title: jsonData.title, colors: jsonData.colors, is3D: true});
        google.visualization.events.addListener(pie, 'select', function() {
          var selection = pie.getSelection();
//          alert('You selected ' + selection[0].row);
          $.getJSON('updatePie', {id: selection[0].row}, function() {
            drawPieChart();
          });
        });
      })
    }

    function createDataTableFromJSON(jsonData) {
      var table = new google.visualization.DataTable();
      table.addRows(jsonData[0].data.length);
      $.each(jsonData, function(i, item) {
        table.addColumn(item.type, item.name);
        $.each(item.data, function(j, cellValue) {
          var value = (i == 0) ? new Date(cellValue) : cellValue;
          table.setValue(j, i, value);
        });
      });
      return table;
    }

    google.setOnLoadCallback(drawVisualization);
    function dateRangeChange() {
      var newDateRange = $('#inputDate').val();
      var dateArray = newDateRange.split(' - ');
      if (dateArray.length == 1) {
        dateArray[1] = dateArray[0];
      }
      jQuery.ajax({
        url: 'changeDateRange',
        type: "POST",
        data: {startDate: dateArray[0] , endDate: dateArray[1]},
        dataType: "json",
        success: function() {
          drawVisualization();
        }
      });
    }
  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.report.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div style="min-width:700px;float :right;  margin:10px;">
    <div>
      <h3><label for="inputDate"><g:message code="dateRange.select"/>:</label></h3>
      <input id="inputDate" type="text" value="1/1/2011 - ${new SimpleDateFormat("M/d/yyyy").format(new Date())}" readonly="true"/>
    </div>
    <div id="tabs">
      <ul>
        <li><a href="#tabs-1" onclick="drawLineChart();"><g:message code="report.chart.line"/></a></li>
        <li><a href="#tabs-2" onclick="drawPieChart();"><g:message code="report.chart.pie"/></a></li>
      </ul>
      <div id="tabs-1">
        <div id="treeDiv" style="min-width:220px; margin:10px;"></div>
        <div id="lineChart" style="min-width: 1000px;display:inline-block;  height: 450px;"></div>
      </div>
      <div id="tabs-2">
        <div id="pieChart" style="min-width: 1000px; height: 450px;"></div>
        <div style="display:inline-block;">
          <g:formRemote name="root" url="[action: 'root']" onSuccess="drawPieChart()">
            <button style="width:150px"><g:message code="chart.pie.root"/></button>
          </g:formRemote>
        </div>
        <div style="display:inline-block;">
          <g:formRemote name="up" url="[action: 'up']" onSuccess="drawPieChart()">
            <button style="width:150px"><g:message code="chart.pie.up"/></button>
          </g:formRemote>
        </div>
      </div>
    </div>
  </div>
  <export:formats/>

</div>
</body>
</html>