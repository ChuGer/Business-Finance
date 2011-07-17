<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.report.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="../js/jquery/jquery-1.6.1.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.tabs.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.widget.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.core.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>

  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart']});
    google.load('visualization', '1', {'packages':['annotatedtimeline']});
  </script>
  <script type="text/javascript">
    $(function() {
      $("#tabs").tabs();
    });

    function drawVisualization() {
      drawLineChart();
      drawPieChart();
    }

    function drawLineChart() {
      // Parse JSON string to JSON object
      $.getJSON("lineChart", function(jsonData) {
        var dataTable = createDataTableFromJSON(jsonData, [0,1,2]);
        new google.visualization.AnnotatedTimeLine(document.getElementById('lineChart'))
                .draw(dataTable, {displayAnnotations: true});
      })
    }

    function drawPieChart() {
      $.getJSON("pieChart", function(jsonData) {
      var dataTable = new google.visualization.DataTable(jsonData, 0.6);
      // Create and draw the visualization.
      new google.visualization.PieChart(document.getElementById('pieChart'))
              .draw(dataTable, {title:"So, how was your day?", colors:['red','black','blue']});
      })
    }

    function createDataTableFromJSON(jsonData, columns) {
      var table = new google.visualization.DataTable();
      table.addRows(jsonData[0].data.length);
      $.each(jsonData, function(i, item) {
        if (columns.indexOf(i) != -1) {
          table.addColumn(item.type, item.name);
          $.each(item.data, function(j, cellValue) {
            (cellValue instanceof Object && cellValue.length == 3) ? table.setValue(j, i, new Date(cellValue[0], cellValue[1], cellValue[2])) : table.setValue(j, i, cellValue);
          });
        }
      });
      return table;
    }
    google.setOnLoadCallback(drawVisualization);
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

  <div id="tabs">
    <ul>
      <li><a href="#tabs-1" onclick="drawLineChart();"><g:message code="report.chart.line"/></a></li>
      <li><a href="#tabs-2" onclick="drawPieChart();"><g:message code="report.chart.pie"/></a></li>
    </ul>
    <div id="tabs-1">
      <div id="lineChart" style="width: 800px; height: 240px;"></div>
    </div>
    <div id="tabs-2">
      <div id="pieChart" style="min-width: 600px; height: 400px;"></div>
    </div>
  </div>
</div>
</body>
</html>