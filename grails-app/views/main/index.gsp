<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.main.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <jsTree:resources/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.dateFormat-1.0.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="../js/full-calendar/fullcalendar.min.js"></script>
  <link rel="stylesheet" href="../css/fullcalendar.css"/>
  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>
  <link rel="stylesheet" media="screen" type="text/css" href="../css/layout.css"/>
  <link rel="stylesheet" media="screen" type="text/css" href="../css/colorpicker.css"/>
  <script type="text/javascript" src="../js/eye.js"></script>
  <script type="text/javascript" src="../js/utils.js"></script>
  <script type="text/javascript" src="../js/layout.js"></script>
  <script type="text/javascript" src="../js/colorpicker.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-ru.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-en-US.js"></script>
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
  </style>
  <script type="text/javascript">

    $(function() {
      createTree();
      createCalendars();
      createColor();
      var lastHoveredNodeId = 'd1';
    });
    var isLoaded = false;
    function createColor() {
      $('#bilPicker').ColorPicker({
        flat : true,
        color: '#0000ff',
        onSubmit: function(hsb, hex, rgb) {
          $('#colorsb').val("#" + hex);
//          $('#bilPicker').ColorPickerHide();
        }
      })
      $('#oprPicker').ColorPicker({
        flat : true,
        color: '#0000ff',
        onSubmit: function(hsb, hex, rgb) {
          $('#colorso').val("#" + hex);
        }
      })

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
    function createOprCategoryButtons(node) {
      //add bill button
      var newid = node.attr("id") + "p";
      var el = $('#' + node.attr("id")).children('a');
      el.append("<div id=" + newid + " class='addButton'>.</div>");

      $("#" + newid).click(function() {
        $("#startDate").val($.format.date(new Date(), "dd/MM/yyyy"));
        $("#endDate").val($.format.date(new Date(), "dd/MM/yyyy"));
        $("#opr-form").dialog("open");
//              var node = $('#treeDiv .jstree-hovered').parent('li');
//              console.log('plus cliked on node = ' + node.attr("id") + ' named ' + node.text())
      });
      //add category bill button
      var newcid = node.attr("id") + "f";
      var cel = $('#' + node.attr("id")).children('a');
      cel.append("<div id=" + newcid + " class='addCatButton'>.</div>");
      $("#" + newcid).click(function() {
        $("#cto-form").dialog("open");
      });
      cel.css("background-color", node.attr("color"));
      cel.css("background", "-moz-linear-gradient(left," + node.attr("color") + " 0%, white 70%)");

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
    function createOprnode(data, textStatus) {
      var parentNodeId = '#d' + $("#crOprcid").val();
      var nodeData = data[1];
      $("#treeDiv").jstree('create', '#' + lastHoveredNodeId, 'inside', nodeData[0], false, true);
//      $("#treeDiv").jstree('check_node',($('#' + nodeData[0].attr.id)) );

      refetchEvents();
    }
    function createCtgOprnode(data, textStatus) {
      var nodeData = data[1];
      $("#treeDiv").jstree('create', '#' + lastHoveredNodeId, 'inside', nodeData[0], false, true);
      createOprCategoryButtons($('#' + nodeData[0].attr.id));
    }

    function createTree() {
      var treeData = $.parseJSON('${treeData}');
      console.log(treeData);
      var tree = $("#treeDiv").jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "checkbox", "json_data", "ui" ,"crrm" ],    //, "hotkeys"  ,"contextmenu"
        hotkeys: {
          "return" : function () {
            $hovered = $('#treeDiv .jstree-hovered');
            if ($hovered.length) {
              alert('Hovered node text: ' + $hovered.text());
            } else {
              alert('No element was hovered over when return was pressed');
            }
          }
        }
//        ,"contextmenu" : {
//          "items" :{
//            "rename" : {
//              // The item label
//              "label"                : "RenBus",
//              // The function to execute upon a click
//              "action"            : function (obj) {
//                this.rename(obj);
//              },
//              // All below are optional
//              "_disabled"            : false,        // clicking the item won't do a thing
//              "_class"            : "class",    // class is applied to the item LI node
//              "separator_before"    : false,    // Insert a separator before the item
//              "separator_after"    : false
//            }
//          }
//        }

      });

      tree.bind("loaded.jstree", function (event, data) {
        tree.jstree("open_all");
        data.inst.get_container().find('li').each(function(i) {
          //restoring check state

          if ($(this).attr("chkd") == 'true') {
            data.inst.check_node($(this));
            if ($(this).attr("type").indexOf('ct') === 0) {
              var cel = $('#' + $(this).attr("id")).children('a');
              cel.css("background-color", $(this).attr("color"));
            }
          }
          else {
            data.inst.uncheck_node($(this));
          }


          //adding [+] divs
          if ($(this).attr("type").indexOf('ctb') === 0) {
            createBillCategoryButtons($(this));
          }
          else if ($(this).attr("type").indexOf('cto') === 0) {
            createOprCategoryButtons($(this));
          }

        });
        isLoaded = true;
      });

      tree.bind("check_node.jstree", function (e, d) {
        if (d.rslt.obj.attr("type").indexOf('ct') === 0) {
          var cel = $('#' + d.rslt.obj.attr("id")).children('a');
          cel.css("background-color", d.rslt.obj.attr("color"));
        }
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
              refetchEvents();
            }
          });
        }
      });
      tree.bind("uncheck_node.jstree", function (e, d) {
        if (d.rslt.obj.attr("type").indexOf('ct') === 0) {
          var cel = $('#' + d.rslt.obj.attr("id")).children('a');
          cel.css("background-color", "#f7fffd");
        }
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
              refetchEvents();
            }
          });
        }
      });
      tree.bind("hover_node.jstree", function (e, d) {
        var pid = d.rslt.obj.attr("id") + "p";
        var pid2 = d.rslt.obj.attr("id") + "f";
        $("#" + pid).animate().css({display: "inline-block"})
        $("#" + pid2).animate().css({display: "inline-block"})
        lastHoveredNodeId = d.rslt.obj.attr("id");
        $("#categoryb").val(lastHoveredNodeId);
        $("#categoryb2").val(lastHoveredNodeId);
        $("#categoryb3").val(lastHoveredNodeId);
        $("#categoryb4").val(lastHoveredNodeId);
      });
      tree.bind("dehover_node.jstree", function (e, d) {
        var pid = d.rslt.obj.attr("id") + "p";
        var pid2 = d.rslt.obj.attr("id") + "f";
        $("#" + pid).animate().css({display: "none"})
        $("#" + pid2).animate().css({display: "none"})

//          d.rslt.obj.css("background-color", 'rgb(110,140,112)');
      });


      tree.bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      });

      tree.bind("create.jstree", function(event, data) {
//        alert(data.rslt.obj.attr("id") + "  " + $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id")));
      });

      tree.bind("select_node.jstree", function (e, d) {
//        createTree();
//        d.rslt.obj.css("background-color", "green")
        var newid = d.rslt.obj.attr("id")  ;
        jQuery.ajax({
            url: 'cliclEvent',
            type: "POST",
            data: {id: newid},
            dataType: "json"
//            ,success:function() {
//              refetchEvents();
//            }
          });
//        $('#treeDiv .jstree-hovered').append("<div id="+newid+" style='  width: 15px; text-align: right'></div>");
//        $("#"+newid).append('z.');

      });

    }

    function selectAll() {
      // TODO fix selectAll btn
      $("#treeDiv").jstree("check_all");
    }

    function createCalendars() {
      $.getJSON("locale", function(json) {
        regional = $.datepicker.regional[json.locale];
        $("#startDate").datepicker(regional);
        $("#endDate").datepicker(regional);
        drawCalendar(regional);
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
      $("#cto-form").dialog({
        autoOpen: false,
        height: 350,
        width: 450,
        modal: true
      });
    }

    function closeDialog() {
      $("#opr-form").dialog("close");
      $("#name").val('');
    }
    function closeBillDialog() {
      $("#bill-form").dialog("close");
    }
    function closeCtgBillDialog() {
      $("#ctb-form").dialog("close");
    }
    function closeOprBillDialog() {
      $("#cto-form").dialog("close");
    }
    function refetchEvents() {
//      console.lod(d[0].type)
      $('#calendar').fullCalendar('refetchEvents');
    }
    function drawCalendar(regional) {
      var calendar = $('#calendar');

      calendar.fullCalendar({
        header: {
          left: '',
          center: 'prev, title, next',
          right: 'today'
        },
        selectable: true,
        selectHelper: true,
        monthNames: regional.monthNames,
        monthNamesShort: regional.monthNamesShort,
        dayNames: regional.dayNames,
        dayNamesShort: regional.dayNamesShort,
        firstDay: 1,
        buttonText: {
          today: regional.currentText
        },
        select: function(start, end, allDay) {
          $("#startDate").val($.format.date(start, "dd/MM/yyyy"));
          $("#endDate").val($.format.date(end, "dd/MM/yyyy"));
          $("#opr-form").dialog("open");
          calendar.fullCalendar('unselect');
        },
        eventClick:  function(event, jsEvent, view) {
          console.log('Delete event with id: ' + event.id);
          jQuery.ajax({
            url: "deleteEvent",
            type: "POST",
            data: {id: event.id},
            dataType: "json",
            complete: function() {
              calendar.fullCalendar('removeEvents', event.id);
            }
          });
        },
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
          console.log(event.id + " " + event.title + " was moved " +
                  dayDelta + " days and " + minuteDelta + " minutes.");
          jQuery.ajax({
            url: 'moveEvent',
            type: "POST",
            data: {id: event.id, dayDelta: dayDelta},
            dataType: "json"
          });
        },
        eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
          console.log("The end date of " + event.title + "has been moved " +
                  dayDelta + " days and " + minuteDelta + " minutes.");
          jQuery.ajax({
            url: 'resizeEvent',
            type: "POST",
            data: {id: event.id, dayDelta: dayDelta},
            dataType: "json"
          });
        },
        editable: true,
        events:
        function(start, end, callback) {
          var view = $('#calendar').fullCalendar('getView');
          $.ajax({
            url: 'events',
            dataType: "json",
            type: "POST",
            data: {start: view.start.getTime(), end: view.end.getTime(), title:view.title},
            success: function(events) {
              callback(events);
            }})
        }
      });
    }

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

  <div>
    <div id="treeDiv" style="width:220px;float:left; margin:10px;"></div>
    <div style="min-width:800px; display: inline-block;margin:10px;" id="calendar"></div>
    <div style="min-width:400px; float: right; background-color:#f5f5f5; border-radius:10px; margin:10px;">
      <h1 style="text-align:center;">${stat.bill.name}</h1>
      <g:message code="main.stat.balance"/>: ${stat.bill.balance}<br/><br/>
      <table>
        <tr>
          <th><g:message code="main.stat.category.name"/></th>
          <th><g:message code="main.stat.category.income"/></th>
          <th><g:message code="main.stat.category.outcome"/></th>
          <th><g:message code="main.stat.category.result"/></th>
        </tr>
        <g:each in="${stat.categories}" var="i">
          <tr>
            <td>${i.categoryName}</td>
            <td>${i.income}</td>
            <td>${i.outcome}</td>
            <td>${i.result}</td>
          </tr>
        </g:each>
         <tr style="background-color:#e6e6fa;">
            <td>${stat.result.categoryName}</td>
            <td>${stat.result.income}</td>
            <td>${stat.result.outcome}</td>
            <td>${stat.result.result}</td>
          </tr>
      </table>
    </div>
  </div>

  <div id="bill-form" title="<g:message code="bill.create"/>">
    <g:hasErrors bean="${billInstance}">
      <div class="errors">
        <g:renderErrors bean="${billInstance}" as="list"/>
      </div>
    </g:hasErrors>
    <g:formRemote name="createBillForm" url="[action: 'addBill']" onSuccess="createBillnode(data,textStatus);" onComplete="closeBillDialog()">
      <div class="dialog">
        <table>
          <tbody>
          <tr class="prop">
            <td valign="top" class="name">
              <label for="billName"><g:message code="bill.name.label" default="Name"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'name', 'errors')}">
              <g:textField id="billName" name="name" value="${billInstance?.name}"/>
            </td>
          </tr>


          <tr class="prop">
            <td valign="top" class="name">
              <label for="currency"><g:message code="bill.currency.label" default="Currency"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'currency', 'errors')}">
              <g:select name="currency" from="${domain.Currency.list()}" optionKey="id" value="${billInstance?.currency?.id}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="balance"><g:message code="bill.balance.label" default="Balance"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'balance', 'errors')}">
              <g:textField id="balance" name="balance" value="${billInstance?.name}"/>
            </td>
          </tr>


          <tr class="prop">
            <td valign="top" class="name">
              <label for="icon"><g:message code="bill.ico.label" default="Icon"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'ico', 'errors')}">
              <g:textField id="icon" name="ico" value="${billInstance?.ico}" readonly="true"/>
            </td>
          </tr>
          <g:hiddenField id="categoryb2" name="categoryb"/>
          <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="addBill" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
          </div>
          </tbody>
        </table>
      </div>
    </g:formRemote>
  </div>

  <div id="ctb-form" title="<g:message code="ctgb.create"/>">
    <g:hasErrors bean="${ctgBInstance}">
      <div class="errors">
        <g:renderErrors bean="${ctgBInstance}" as="list"/>
      </div>
    </g:hasErrors>
    <g:formRemote name="createCategoryBForm" url="[action: 'addBillCategory']" onSuccess="createCtgBillnode(data,textStatus);" onComplete="closeCtgBillDialog();">
      <div class="dialog">
        <table>
          <tbody>
          <tr class="prop">
            <td valign="top" class="name">
              <label for="billName"><g:message code="ctgb.name.label" default="Name"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'name', 'errors')}">
              <g:textField id="billName" name="name" value="${ctgBInstance?.name}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="bilPicker"><g:message code="ctgb.color.label" default="Color"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'color', 'errors')}">
              <g:hiddenField id="colorsb" name="color" value="${ctgOInstance?.color}"/>
              <div id="bilPicker"></div>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="icon"><g:message code="ctgb.ico.label" default="Icon"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'ico', 'errors')}">
              <g:textField id="icon" name="ico" value="${ctgBInstance?.ico}" readonly="true"/>
            </td>
          </tr>
          <g:hiddenField id="categoryb" name="categoryb"/>
          <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="addBillCategory" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
          </div>
          </tbody>
        </table>
      </div>
    </g:formRemote>
  </div>

  <div id="cto-form" title="<g:message code="ctgo.create"/>">
    <g:hasErrors bean="${ctgOInstance}">
      <div class="errors">
        <g:renderErrors bean="${ctgOInstance}" as="list"/>
      </div>
    </g:hasErrors>
    <g:formRemote name="createCategoryOForm" url="[action: 'addOprCategory']" onSuccess="createCtgOprnode(data,textStatus);" onComplete="closeCtgOprDialog()">
      <div class="dialog">
        <table>
          <tbody>
          <tr class="prop">
            <td valign="top" class="name">
              <label for="ctgO.Name"><g:message code="ctgo.name.label" default="Name"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'name', 'errors')}">
              <g:textField id="ctgO.Name" name="name" value="${ctgOInstance?.name}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="oprPicker"><g:message code="ctgo.color.label" default="Color"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgOInstance, field: 'color', 'errors')}">
              <g:hiddenField id="colorso" name="color" value="${ctgOInstance?.color}"/>
              <div id="oprPicker"></div>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="ctgO.icon"><g:message code="ctgo.ico.label" default="Icon"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: ctgOInstance, field: 'ico', 'errors')}">
              <g:textField id="ctgO.icon" name="ico" value="${ctgOInstance?.ico}"/>
            </td>
          </tr>
          <g:hiddenField id="categoryb3" name="categoryb"/>
          <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="addBillCategory" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
          </div>
          </tbody>
        </table>
      </div>
    </g:formRemote>
  </div>

  <div id="opr-form" title="<g:message code="operation.create"/>">
    <g:hasErrors bean="${operationInstance}">
      <div class="errors">
        <g:renderErrors bean="${operationInstance}" as="list"/>
      </div>
    </g:hasErrors>
    <g:formRemote name="createForm" method="post" url="[action: 'addEvent']" onSuccess="createOprnode(data,textStatus);" onComplete="closeDialog();">
      <div class="dialog">
        <table>
          <tbody>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="name"><g:message code="operation.name.label" default="Name"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'name', 'errors')}">
              <g:textField name="name" value="${operationInstance?.name}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="bill.id"><g:message code="operation.bill.label" default="Bill"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'bill', 'errors')}">
              <g:select name="bill.id" from="${domain.Bill.list()}" optionKey="id" value="${operationInstance?.bill?.id}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="sum"><g:message code="operation.sum.label" default="Sum"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'sum', 'errors')}">
              <g:textField name="sum" value="${fieldValue(bean: operationInstance, field: 'sum')}"/>
            </td>
          </tr>


          <tr class="prop">
            <td valign="top" class="name">
              <label for="type"><g:message code="operation.type.label" default="Type"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'type', 'errors')}">
              <g:radioGroup name="type" labels="['outcome','income']" values="[0,1]" value="${fieldValue(bean: operationInstance, field: 'type')}">
                <div style="display:inline-block;">
                  <p>${it.radio} <g:message code="operation.type.${it.label}"/></p>
                </div>
              </g:radioGroup>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="startDate"><g:message code="operation.startDate.label" default="Start Date"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'startDate', 'errors')}">
              <g:textField name="startDate" id="startDate" precision="day" value="${operationInstance?.startDate}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="endDate"><g:message code="operation.endDate.label" default="End Date"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'endDate', 'errors')}">
              <g:textField name="endDate" id="endDate" precision="day" value="${operationInstance?.endDate}" default="none" noSelection="['': '']"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="category.id"><g:message code="operation.category.label" default="Category"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'category', 'errors')}">
              <g:select id="crOprcid" name="category.id" from="${domain.CategoryOp.list()}" optionKey="id" value="${operationInstance?.category?.id}"/>
            </td>
          </tr>

          <g:hiddenField id="categoryb4" name="categoryb"/>
          <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="addEvent" value="${message(code: 'default.button.save.label', default: 'Update')}"/></span>
          </div>
          </tbody>
        </table>
      </div>
    </g:formRemote>
  </div>

</div>

</body>
</html>

