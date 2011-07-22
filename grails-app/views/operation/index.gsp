<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.operation.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.dateFormat-1.0.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-ru.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-en-US.js"></script>
  <script type="text/javascript" src="../js/daterangepicker.jQuery.js"></script>
  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>
  <link rel="stylesheet" href="../css/ui.daterangepicker.css" type="text/css"/>
  <script type="text/javascript">

    $(function() {
      createDialog();
      $('#inputDate').daterangepicker({arrows:true});
      refreshTable();
    });

    function refreshTable() {
      $.ajax({
        url: 'createTable',
        type: "POST",
        complete: function(data) {
          $('#table').html(data.responseText);
        }
      })
    }

    function createDialog() {
      $.getJSON("locale", function(json) {
        regional = $.datepicker.regional[json.locale];
        $("#startDate").datepicker(regional);
      });

      $("#opr-form").dialog({
        autoOpen: false,
        height: 400,
        width: 350,
        modal: true
      });
    }

    function closeDialog() {
      $("#opr-form").dialog("close");
      $("#name").val('');
      refreshTable();
    }

    function showDialog() {
      $("#opr-form").dialog("open");
    }
  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.operation.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <input id="inputDate" type="text" value="4/23/99"/>
  <g:render template="oprForm" bean="${operationInstance}"/>
  <div id="table"></div>
  <br/><br/>
  <a onclick="showDialog();"><g:message code="operation.add" default="Add transaction"/></a>
  <br/><br/>
  <a onclick="refreshTable();"><g:message code="operation.add" default="Refresh table"/></a>

</div>
</body>
</html>

