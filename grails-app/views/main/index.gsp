<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title><g:message code="menu.main.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <jsTree:resources/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/full-calendar/fullcalendar.min.js"></script>
  <link rel="stylesheet" href="../css/fullcalendar.css"/>
  <link rel="stylesheet" href="../css/ui-lightness/jquery-ui-1.8.11.custom.css"/>
  <script type="text/javascript">

    $(function() {
      createTree();
      drawCalendar();
      dialog();
    });

    function createTree() {
      var treeData = $.parseJSON('${treeData}');
      var tree = $("#treeDiv").jstree({
        "json_data" : {"data" : [treeData]},
        "plugins" : [ "themes", "checkbox", "json_data", "ui" ,"contextmenu","crrm"]
      });

      tree.bind("check_node.jstree", function (e, d) {
        var sname = $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id"));
        var sid = d.rslt.obj.attr("id")
        alert(sid + "  " + sname);
        jQuery.ajax({
          url: 'treeCheck',
          type: "POST",
          data: {name: sname, id: sid },
          dataType: "json"
        });
      });

      tree.bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      });

      tree.bind("create.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id")));
      });

      tree.bind("select_node.jstree", function (e, d) {
        alert(d.rslt.obj.attr("id") + " id  clicked  " + $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id")));
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
          left: 'prev,next today',
          center: 'title',
          right: 'month'
        },
        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {
          $("#startDate").val(start);
          $("#endDate").val(end);
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
            beforeSend: function(x) {
              if (x && x.overrideMimeType) {
                x.overrideMimeType("application/json;charset=UTF-8");
              }
            },
            success: function(result) {
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

  <table>
    <tr>
      <td width="200px;">
        <div id="treeDiv"></div>
        <button id="selectAll" onclick="selectAll();">selectAll</button>
      </td>
      <td>
        <g:remoteLink action="clearCalendar" onComplete="drawCalendar()">clearCalendar</g:remoteLink><br/>
        <div style="width:800px;" id="calendar"></div>

        <div id="dialog-form" title="<g:message code="operation.create"/>">

          <g:formRemote name="createForm" method="post" url="[action:'addEvent']" onComplete="closeDialog();drawCalendar();">
            <fieldset>
              <table>
                <tr>
                  <td>
                    <label for="name">Name</label>
                  </td>
                  <td>
                    <input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label for="startDate">StartDate</label>
                  </td>
                  <td>
                    <input type="text" name="startDate" id="startDate" class="text ui-widget-content ui-corner-all"/> <br/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <label for="endDate">EndDate</label>
                  </td>
                  <td>
                    <input type="text" name="endDate" id="endDate" class="text ui-widget-content ui-corner-all"/>
                  </td>
                </tr>
              </table>
              <g:actionSubmit value="${message(code: 'default.button.update.label', default: 'Update')}"/>
            </fieldset>
          </g:formRemote>
        </div>
      </td>
    </tr>
  </table>

</body>
</html>

