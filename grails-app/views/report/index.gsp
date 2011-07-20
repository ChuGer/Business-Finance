<%@ page contentType="text/html;charset=UTF-8" %>
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
  <export:resource/>

  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart'], timeout: 5000});
    google.load('visualization', '1', {packages: ['annotatedtimeline'], timeout: 5000});
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
      <div id="lineChart" style="min-width: 1000px; height: 450px;"></div>
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
  <export:formats/>

</div>
</body>
</html>