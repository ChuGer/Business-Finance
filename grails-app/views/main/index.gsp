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
  <link rel="stylesheet" href="../css/ui-lightness/jquery-ui-1.8.11.custom.css"/>
  <link rel="stylesheet" media="screen" type="text/css" href="../css/layout.css" />
  <link rel="stylesheet" media="screen" type="text/css" href="../css/colorpicker.css"/>
  <script type="text/javascript" src="../js/eye.js"></script>

    <script type="text/javascript" src="../js/utils.js"></script>
    <script type="text/javascript" src="../js/layout.js"></script>
  <script type="text/javascript" src="../js/colorpicker.js"></script>
  <script type="text/javascript">

    $(function() {
      createTree();
      drawCalendar();
      dialog();
      createColor();
    });
    var isLoaded = false;
    function createColor()  {
        $('#colorpickerHolder2').ColorPicker({
			flat: true,
			color: '#00ff00',
			onSubmit: function(hsb, hex, rgb) {
				$('#colorSelector2 div').css('backgroundColor', '#' + hex);
			}
		});
		$('#colorpickerHolder2 div').css('position', 'absolute');
		var widt = false;
		$('#colorSelector2').bind('click', function() {
			$('#colorpickerHolder2').stop().animate({height: widt ? 0 : 173}, 500);
			widt = !widt;
		});
	};

    function createTree() {
      var treeData = $.parseJSON('${treeData}');
      var tree = $("#treeDiv").jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "checkbox", "json_data", "ui" ,"contextmenu","crrm" , "hotkeys"],
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
      });

      tree.bind("loaded.jstree", function (event, data) {
        tree.jstree("open_all");
        data.inst.get_container().find('li').each(function(i) {
          //restoring check state
          if ($(this).attr("chkd") == 'true') {
            data.inst.check_node($(this));
          }
          else {
            data.inst.uncheck_node($(this));
          }
          //adding [+] divs
          var newid = $(this).attr("id") + "p";
//          var el = ($(this).attr("type") == "bill") ? $('#' + $(this).attr("id") + ' :last-child') : $('#' + $(this).attr("id") + ' :first-child')
          var el = $('#' + $(this).attr("id")).children('a')
          el.append("<div id=" + newid + " style='  width: 25px; visibility: hidden; background-color: lime; '></div>");
          $("#" + newid).append('[+]');

          $("#" + newid).click(function() {
            var node = $('#treeDiv .jstree-hovered').parent('li')
            console.log('plus cliked on node = ' + node.attr("id") + ' named ' + node.text())
          });
        });
        isLoaded = true;
      });

      tree.bind("check_node.jstree", function (e, d) {
        if (isLoaded) {
          d.rslt.obj.css("background-color", "green")
          var sname = $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id"));
          var sid = d.rslt.obj.attr("id")
          var stype = d.rslt.obj.attr("type")
          jQuery.ajax({
            url: 'treeCheck',
            type: "POST",
            data: {name: sname, id: sid, type: stype},
            dataType: "json",
            complete: drawCalendar()
          });
        }
      });
      tree.bind("hover_node.jstree", function (e, d) {
        var pid = d.rslt.obj.attr("id") + "p";
        $("#" + pid).animate().css({visibility: "visible"})
//          d.rslt.obj.css("background-color", d.rslt.obj.attr("color"));
      });
      tree.bind("dehover_node.jstree", function (e, d) {
        var pid = d.rslt.obj.attr("id") + "p";
        $("#" + pid).animate().css({visibility: "hidden"})

//          d.rslt.obj.css("background-color", 'rgb(110,140,112)');
      });
      tree.bind("uncheck_node.jstree", function (e, d) {
        if (isLoaded) {
          d.rslt.obj.css("background-color", "red")
          var sname = $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id"));
          var sid = d.rslt.obj.attr("id")
          var stype = d.rslt.obj.attr("type")
          jQuery.ajax({
            url: 'treeCheck',
            type: "POST",
            data: {name: sname, id: sid, type: stype},
            dataType: "json",
            complete: drawCalendar()
          });
        }
      });

      tree.bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      });

      tree.bind("create.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id")));
      });

      tree.bind("select_node.jstree", function (e, d) {
//        d.rslt.obj.css("background-color", "green")
        var newid = d.rslt.obj.attr("id") + "p";
//        $('#treeDiv .jstree-hovered').append("<div id="+newid+" style='  width: 15px; text-align: right'></div>");
//        $("#"+newid).append('z.');

      });

    }

    function selectAll() {
      $("#treeDiv").jstree("check_all");
    }

    function dialog() {
      $("#startDate").datepicker();
      $("#endDate").datepicker();
      $("#dialog-form").dialog({
        autoOpen: false,
        height: 400,
        width: 350,
        modal: true
      });
    }

    function closeDialog() {
      $("#dialog-form").dialog("close");
      $("#name").val('');
    }

    function drawCalendar() {
      var calendar = $('#calendar');
      calendar.html('');
      calendar.fullCalendar({
        header: {
          left: '',
          center: 'prev, title, next',
          right: 'today'
        },
        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {
          $("#startDate").val($.format.date(start, "MM/dd/yyyy"));
          $("#endDate").val($.format.date(end, "MM/dd/yyyy"));
          $("#dialog-form").dialog("open");
//          var title = prompt('Title:');
//          if (title) {
//            calendar.fullCalendar('renderEvent',
//            {
//              title: title,
//              start: start,
//              end: end,
//              allDay: allDay
//            },
//                    true // make the event "stick"
//                    );
//          }
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
          if (!confirm("Want to revert deleted event?")) {
            revertFunc();
          }
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
//          if (!confirm("Are you sure about this change?")) {
//            revertFunc();
//          }
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
//          if (!confirm("is this okay?")) {
//            revertFunc();
//          }
        },
        editable: true,
        events: 'events'
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
  <div id="customWidget">
  <div id="colorSelector2">   </div>
    <div id="colorpickerHolder2">  </div>
    </div>
  <table>
    <tr>
      <td width="200px;">
        <div id="treeDiv"></div>
        <button id="selectAll" onclick="selectAll();">selectAll</button>
      </td>
      <td>
        <div style="width:800px;" id="calendar"></div>
      </td>
    </tr>
  </table>

    <div id="bill-form" title="<g:message code="bill.create"/>">
    <g:hasErrors bean="${operationInstance}">
      <div class="errors">
        <g:renderErrors bean="${operationInstance}" as="list"/>
      </div>
    </g:hasErrors>
         <g:formRemote name="createBillForm" method="post" url="[action: 'addBill']" onComplete="closeDialog();drawCalendar();">
      <div class="dialog">
        <table>
          <tbody>
          </tbody>
        </table>
      </div>
    </g:formRemote>
    </div>

  <div id="dialog-form" title="<g:message code="operation.create"/>">
    <g:hasErrors bean="${operationInstance}">
      <div class="errors">
        <g:renderErrors bean="${operationInstance}" as="list"/>
      </div>
    </g:hasErrors>
    <g:formRemote name="createForm" method="post" url="[action: 'addEvent']" onComplete="closeDialog();drawCalendar();">
      <div class="dialog">
        <table>
          <tbody>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="name"><g:message code="operation.name.label" default="Name"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'name', 'errors')}">
              <g:textField id="name" name="name" value="${operationInstance?.name}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="startDate"><g:message code="operation.startDate.label" default="Start Date"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'startDate', 'errors')}">
              <g:textField id="startDate" name="startDate" precision="day" value="${operationInstance?.startDate}"/>
            </td>
          </tr>

          <tr class="prop">
            <td valign="top" class="name">
              <label for="endDate"><g:message code="operation.endDate.label" default="End Date"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'endDate', 'errors')}">
              <g:textField id="endDate" name="endDate" precision="day" value="${operationInstance?.endDate}" default="none" noSelection="['': '']"/>
            </td>
          </tr>
          %{--FIXME !! Error executing tag <g:formRemote>: Error evaluating expression [operationInstance.constraints.type.inList] on line [219]:--}%
          %{--<tr class="prop">--}%
          %{--<td valign="top" class="name">--}%
          %{--<label for="type"><g:message code="operation.type.label" default="Type"/></label>--}%
          %{--</td>--}%
          %{--<td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'type', 'errors')}">--}%
          %{--<g:select name="type" from="${operationInstance.constraints.type.inList}" value="${fieldValue(bean: operationInstance, field: 'type')}" valueMessagePrefix="operation.type"/>--}%
          %{--</td>--}%
          %{--</tr>--}%

          <tr class="prop">
            <td valign="top" class="name">
              <label for="bill"><g:message code="operation.bill.label" default="Bill"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'bill', 'errors')}">
              <g:select name="bill.id" from="${domain.Bill.list()}" optionKey="id" value="${operationInstance?.bill?.id}"/>
            </td>
          </tr>
          <div class="buttons">
            <span class="button"><g:actionSubmit class="save" action="addEvent" value="${message(code: 'default.button.update.label', default: 'Update')}"/></span>
            <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
          </div>
          </tbody>
        </table>
      </div>
    </g:formRemote>
  </div>

</div>
</body>
</html>

