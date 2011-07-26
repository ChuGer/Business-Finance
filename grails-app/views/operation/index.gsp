<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.operation.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <jsTree:resources/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.dateFormat-1.0.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-ru.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-en-US.js"></script>
  <script type="text/javascript" src="../js/daterangepicker.jQuery.js"></script>
  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>
  <link rel="stylesheet" href="../css/ui.daterangepicker.css" type="text/css"/>
  <link rel="stylesheet" media="screen" type="text/css" href="../css/layout.css"/>
  <link rel="stylesheet" media="screen" type="text/css" href="../css/colorpicker.css"/>
  <script type="text/javascript" src="../js/eye.js"></script>
  <script type="text/javascript" src="../js/utils.js"></script>
  <script type="text/javascript" src="../js/layout.js"></script>
  <script type="text/javascript" src="../js/colorpicker.js"></script>
  <style type="text/css">
  .addCatButton {
    width: 24px;
    background-image: url('../images/tree/layer--plus.png');
    background-repeat: no-repeat;
    display: none;
    text-indent: -300px;
  }

  .addButton {
    width: 24px;
    background-image: url('../images/tree/plus.png');
    background-repeat: no-repeat;
    display: none;
    text-indent: -300px;
  }

  #addOperationButton {
    display: inline-block;
  }

  td {
    min-width: 150px;
  }
  </style>
  <script type="text/javascript">
    $(function() {
      var lastHoveredNodeId;
      createDialog();
      createTree();
      createColor();
      $('#inputDate').daterangepicker({
        arrows:true,
        onChange: function() {
          dateRangeChange();
        }
      });
      refreshTable();
    });
    function createColor() {
      $('#bilPicker').ColorPicker({
        flat : true,
        color: '#0000ff',
        onSubmit: function(hsb, hex, rgb) {
          $('#colorsb').val("#" + hex);
//          $('#bilPicker').ColorPickerHide();
        }
      })
    }
    function refreshTable() {
      $.ajax({
        url: 'incomeTable',
        type: "POST",
        complete: function(data) {
          var responseText = data.responseText;
          $('#incomeTable').html(responseText);
          //TODO: remove indus code responseText.length > 10
          $('#incomeTableHeader').css('display', responseText.length > 10 ? 'block' : 'none');
        }
      })
      $.ajax({
        url: 'outcomeTable',
        type: "POST",
        complete: function(data) {
          var responseText = data.responseText;
          $('#outcomeTable').html(responseText);
          //TODO: remove indus code responseText.length > 10
          $('#outcomeTableHeader').css('display', responseText.length > 10 ? 'block' : 'none');
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
      $("#bill-form").dialog({
        autoOpen: false,
        height: 400,
        width: 350,
        modal: true
      });
      $("#ctb-form").dialog({
        autoOpen: false,
        height: 350,
        width: 450,
        modal: true
      });
    }
    function createBillCategoryButtons(node) {
      //add bill button
      var newid = node.attr("id") + "p";
      var el = $('#' + node.attr("id")).children('a');
      el.append("<div id=" + newid + " class='addButton'>.</div>");

      $("#" + newid).click(function() {
        $("#bill-form").dialog("open");
//              var node = $('#treeDiv .jstree-hovered').parent('li');
//              console.log('plus cliked on node = ' + node.attr("id") + ' named ' + node.text())
      });
      //add category bill button
      var newcid = node.attr("id") + "f";
      var cel = $('#' + node.attr("id")).children('a');
      cel.append("<div id=" + newcid + " class='addCatButton'>.</div>");
      $("#" + newcid).click(function() {
        $("#ctb-form").dialog("open");
      });

      cel.css("background-color", node.attr("color"));
      cel.css("background", "-moz-linear-gradient(left," + node.attr("color") + " 0%, white 70%)");
//      -webkit-gradient(linear, left top, right top, color-stop(0%,#fefefd), color-stop(42%,#dce3c4), color-stop(100%,#aebf76))
//      cel.css("background", "-webkit-gradient(linear, left top, right top, color-stop(0%," + node.attr("color") + "), color-stop(70%,white)");
    }
    function createBillnode(data, textStatus) {
      var nodeData = data[1];
      $("#treeDiv").jstree('create', '#' + lastHoveredNodeId, 'inside', nodeData[0], false, true);

    }
    function createCtgBillnode(data, textStatus) {
      var nodeData = data[1];
      $("#treeDiv").jstree('create', '#' + lastHoveredNodeId, 'inside', nodeData[0], false, true);
      createBillCategoryButtons($('#' + nodeData[0].attr.id));
    }
    function closeDialog() {
      $("#opr-form").dialog("close");
      $("#name").val('');
      refreshTable();
    }
    function closeBillDialog() {
      $("#bill-form").dialog("close");
      $("#name").val('');
//      refreshTable();
    }
    function showDialog() {
      $("#opr-form").dialog("open");
    }
    function createTree() {
      var treeData = $.parseJSON('${treeData}');
      console.log(treeData);
      var tree = $("#treeDiv").jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "json_data", "ui" ,"crrm" ]
      });

      tree.bind("loaded.jstree", function (event, data) {
        tree.jstree("open_all");
        data.inst.get_container().find('li').each(function(i) {

          //adding [+] divs
          if ($(this).attr("type").indexOf('ctb') === 0) {
            createBillCategoryButtons($(this));
          }

        });
        isLoaded = true;
      });

      tree.bind("hover_node.jstree", function (e, d) {
        var prefix = d.rslt.obj.attr("id").substr(0, 1);
        var pid = d.rslt.obj.attr("id") + "p";
        var pid2 = d.rslt.obj.attr("id") + "f";
        $("#" + pid).animate().css({display: "inline-block"})
        $("#" + pid2).animate().css({display: "inline-block"})
        if (prefix == 'd' || prefix == 'c') {
          lastHoveredNodeId = d.rslt.obj.attr("id");
          $("#categoryb").val(lastHoveredNodeId);
          $("#categoryb2").val(lastHoveredNodeId);
//          $("#categoryb3").val(lastHoveredNodeId);
//          $("#categoryb4").val(lastHoveredNodeId);
        }
        if (prefix == 'd') {
          $("select#crOprcid").val(lastHoveredNodeId.substr(1, lastHoveredNodeId.length));
        }
      });
      tree.bind("dehover_node.jstree", function (e, d) {
        var pid = d.rslt.obj.attr("id") + "p";
        var pid2 = d.rslt.obj.attr("id") + "f";
        $("#" + pid).animate().css({display: "none"})
        $("#" + pid2).animate().css({display: "none"})
      });

      tree.bind("select_node.jstree", function (e, d) {
//        createTree();
//        d.rslt.obj.css("background-color", "green")   $("select#crOprcid").val( lastHoveredNodeId.substr(1,lastHoveredNodeId.length));
        var newid = d.rslt.obj.attr("id");
        if (newid.substr(0, 1) == 'b') {
          jQuery.ajax({
            url: 'clickEvent',
            type: "POST",
            data: {id: newid},
            dataType: "json",
            complete: function() {
              refreshTable();
            }
          });
        }
      });
    }

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
          refreshTable();
        }
      });
    }

  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div>
    <div style="float:left;">
      <h1><g:message code="tree.root.bills"/></h1>
      <div id="treeDiv"></div>
      <br/>
    </div>
    <div style="display:inline-block; margin-left: 50px; min-width:500px;">
      <div style="display:inline-block;">
        <h1><g:message code="menu.operation.title"/></h1>
      </div>
      <div id="addOperationButton" onclick="showDialog();">
        <img src="../images/netvibes.png" style="width:24px;"/>
      </div>
      <br/>
      <div>
        <h3><label for="inputDate"><g:message code="dateRange.select"/>:</label></h3>
        <input id="inputDate" type="text" value="${new SimpleDateFormat("M/d/yyyy").format(new Date())}" readonly="true"/>
      </div>
      <g:render template="oprForm" bean="${operationInstance}"/>
      <g:render template="bilForm" bean="${billInstance}"/>
      <g:render template="ctbForm" bean="${ctgBInstance}"/>
      <table>
        <h1 id="incomeTableHeader"><g:message code="operation.type.income"/></h1>
        <div id="incomeTable"></div>
        <h1 id="outcomeTableHeader"><g:message code="operation.type.outcome"/></h1>
        <div id="outcomeTable"></div>
      </table>
    </div>
  </div>

</div>
</body>
</html>

