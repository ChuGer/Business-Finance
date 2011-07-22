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
      $('input').daterangepicker({arrows:true});
    });

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
    }
    function showDialog() {
      $("#opr-form").dialog("open");
    }
  </script>

  <style type="text/css">
  body {
    font-size: 62.5%;
  }

  input {
    width: 196px;
    height: 1.1em;
    display: block;
  }
  </style>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.operation.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <input type="text" value="4/23/99" id="rangeA"/>

  <table>
    <tr>
      <th><h2><g:message code="operation.name.label"/></h2></th>
      <th><h2><g:message code="operation.sum.label"/></h2></th>
      <th><h2><g:message code="operation.startDate.label"/></h2></th>
    </tr>
    <g:each in="${rootCat.categories}" var="i">
      <tr>
        <th style="background: ${i.color}; color: white;">
          <h3>${i.name}</h3>
        </th>
      </tr>
      <g:each in="${i.operations}" var="io">
        <tr>
          <td>${io.name}</td>
          <td>${io.sum}</td>
          %{--<td><%=new SimpleDateFormat("dd/MM/yyyy").format({io.startDate})%></td>--}%
          <td>${io.startDate.dateString}</td>
        </tr>
      </g:each>
      <g:each in="${i.categories}" var="ic">
        <tr>
          <th style="background: ${ic.color}; color: white;"><g:message code="all.space.formatter"/>${ic.name}</th>
        </tr>
        <g:each in="${i.operations}" var="ioi">
          <tr>
            <td><g:message code="all.space.formatter"/>${ioi.name}</td>
            <td>${ioi.sum}</td>
            <td>${ioi.startDate.dateString}</td>
          </tr>
        </g:each>
      </g:each>
    </g:each>
  </table>

  <br/><br/><br/><a onclick="showDialog();"><g:message code="operation.add" default="Add transaction"/></a>
  <g:render template="oprForm" bean="${operationInstance}"/>

</div>
</body>
</html>

