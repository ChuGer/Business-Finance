<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Chart example</title>
  <script type="text/javascript" src="../js/jquery/jquery-1.4.2.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>

  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart']});
    google.load('visualization', '1', {'packages':['annotatedtimeline']});
  </script>
  <script type="text/javascript">
    function drawVisualization() {
      // Parse JSON string to JSON object
      var jsonData = $.parseJSON('${chartData}');
      var dataTable = createDataTableFromJSON(jsonData, [0,1,2]);

      var dataJSON = $.parseJSON('${dataTableJSON}');
      var dataTable2 = new google.visualization.DataTable(dataJSON, 0.6);
      // Create and draw the visualization.
      new google.visualization.PieChart(document.getElementById('visualization')).draw(dataTable2, {title:"So, how was your day?", colors:['red','black','blue']});
      new google.visualization.LineChart(document.getElementById('chart_div')).draw(dataTable2, {width: 600, height: 300, title: 'Company Performance'});
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

<div id="visualization" style="width: 600px; height: 600px;"></div>
<div id="chart_div" style="width: 600px; height: 600px;"></div>
<div id='annotated' style='width: 700px; height: 240px;'></div>
<br/>

%{--<br/>--}%
%{--<g:barChart--}%
%{--title='Sample Bar Chart' size="${chartData.size}"--}%
%{--colors="${chartData.colors}" type="bvs"--}%
%{--labels="${chartData.labels}" zeroLine="${'0.5'}" axes="x,y"--}%
%{--axesLabels="${chartData.axesLabels}" fill="${'bg,s,efefef'}"--}%
%{--dataType='simple' data='${chartData.values}'/>--}%
%{--<br/>--}%
%{--<br/>--}%
%{--<g:pieChart--}%
%{--title='Sample Bar Chart' size="${chartData.size}"--}%
%{--colors="${chartData.colors}" type="bvs"--}%
%{--labels="${chartData.labels}" zeroLine="${'0.5'}" axes="x,y"--}%
%{--axesLabels="${chartData.axesLabels}" fill="${'bg,s,efefef'}"--}%
%{--dataType='simple' data='${chartData.values}'/>--}%

</body>
</html>