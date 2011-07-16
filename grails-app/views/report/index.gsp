<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.report.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart']});
    google.load('visualization', '1', {'packages':['annotatedtimeline']});
    function drawVisualization() {
      // Parse JSON string to JSON object
      var jsonData = $.parseJSON('${chartData}');
      var dataTable = createDataTableFromJSON(jsonData, [0,1,2]);

      var dataJSON = $.parseJSON('${dataTableJSON}');
      var dataTable2 = new google.visualization.DataTable(dataJSON, 0.6);
      // Create and draw the visualization.
      new google.visualization.PieChart(document.getElementById('visualization')).draw(dataTable2, {title:"So, how was your day?", colors:['red','black','blue']});
      new google.visualization.AnnotatedTimeLine(document.getElementById('annotated')).draw(dataTable, {displayAnnotations: true});
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

  <div id="visualization" style="width: 600px; height: 600px;"></div>
  <div id='annotated' style='width: 700px; height: 240px;'></div>
</div>
</body>
</html>

