<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Simple GSP page</title>
  <script type="text/javascript" src="../js/jquery/jquery-1.4.2.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>

  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="http://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart']});
  </script>
  <script type="text/javascript">
    function drawVisualization() {
      // Create and populate the data table.
      var chartData =  $.parseJSON('${json}');
      var dataTable = new google.visualization.DataTable();
      dataTable.addRows(chartData[0].data.length);
      $.each(chartData, function(i, item) {
        dataTable.addColumn(item.type, item.name);
        $.each(item.data, function(j, cellValue) {
          dataTable.setValue(j,i,cellValue);
        });
      });
      // Create and draw the visualization.
      new google.visualization.PieChart(document.getElementById('visualization')).draw(dataTable, {title:"So, how was your day?"});

      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(dataTable, {width: 600, height: 300, title: 'Company Performance'});

    }
    google.setOnLoadCallback(drawVisualization);
  </script>
</head>
<body>

<div id="visualization" style="width: 600px; height: 600px;"></div>
<div id="chart_div" style="width: 600px; height: 600px;"></div>

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