<%--
  Created by IntelliJ IDEA.
  User: Acer5740
  Date: 11.07.11
  Time: 17:44
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="businessfinance.CalendarController" contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Simple GSP page</title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="../js/full-calendar/fullcalendar.min.js"></script>
  <link rel="stylesheet" href="../css/fullcalendar.css"/>
  <link rel="stylesheet" href="../css/ui-lightness/jquery-ui-1.8.11.custom.css"/>
  <style>
  body {
    font-size: 72.5%;
  }

  label, input {
    display: block;
  }

  input.text {
    margin-bottom: 12px;
    width: 95%;
    padding: .4em;
  }

  fieldset {
    padding: 0;
    border: 0;
    margin-top: 25px;
  }

  h1 {
    font-size: 1.2em;
    margin: .6em 0;
  }

  div#users-contain {
    width: 350px;
    margin: 20px 0;
  }

  div#users-contain table {
    margin: 1em 0;
    border-collapse: collapse;
    width: 100%;
  }

  div#users-contain table td, div#users-contain table th {
    border: 1px solid #eee;
    padding: .6em 10px;
    text-align: left;
  }

  .ui-dialog .ui-state-error {
    padding: .3em;
  }

  .validateTips {
    border: 1px solid transparent;
    padding: 0.3em;
  }
  </style>
  <script type="text/javascript">
    $(function() {
      drawCalendar();
      dialog();
    });

    function dialog() {
      $("#startDate").datepicker();
      $("#endDate").datepicker();

      $("#dialog-form").dialog({
        autoOpen: false,
        height: 400,
        width: 350,
        modal: true
//        ,
//        buttons: {
//          "Create an account": function() {
//            $(this).dialog("close");
//          },
//          Cancel: function() {
//            $(this).dialog("close");
//          }
//        },
//        close: function() {
//          allFields.val("").removeClass("ui-state-error");
//        }
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
          right: 'month,agendaWeek,agendaDay'
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

    //    var jsonObjects = [
    //      {id:1, name:"amit"},
    //      {id:2, name:"ankit"},
    //      {id:3, name:"atin"},
    //      {id:1, name:"puneet"}
    //    ];
    //    function postTreeData() {
    //      $.ajax({
    //        type: "POST",
    //        url: "savedata",
    //        contentType : "text/plain",
    //        dataType: 'json',
    //        data: JSON.stringify(jsonObjects),
    //        beforeSend: function(x) {
    //          if (x && x.overrideMimeType) {
    //            x.overrideMimeType("application/json;charset=UTF-8");
    //          }
    //        },
    //        complete: function(jqXHR, textStatus) {
    //          if (jqXHR.readyState === 4) {
    //            alert(textStatus);
    //          }
    //        },
    //        success: function(result) {
    //          alert(result);
    //        }
    //      });
    //    };

  </script>
</head>
<body>
<g:remoteLink action="showCalendar" onComplete="drawCalendar()">showCalendar</g:remoteLink><br/>
<g:remoteLink action="clearCalendar" onComplete="drawCalendar()">clearCalendar</g:remoteLink><br/>
<div style="width:800px;" id="calendar"></div>
%{--<g:timeZoneSelect name="myTimeZone" value="${tz}"/>--}%

<div id="dialog-form" title="Create new user">
  <p class="validateTips">All form fields are required.</p>

  <g:formRemote name="createForm" method="post" url="[action:'aloe']" onComplete="closeDialog();drawCalendar();">
    <fieldset>
      <label for="name">Name</label>
      <input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all"/>
      <label for="startDate">StartDate</label>
      <input type="text" name="startDate" id="startDate" class="text ui-widget-content ui-corner-all"/> <br/>
      <label for="endDate">EndDate</label>
      <input type="text" name="endDate" id="endDate" class="text ui-widget-content ui-corner-all"/>
      <g:actionSubmit value="${message(code: 'default.button.update.label', default: 'Update')}"/>
    </fieldset>
  </g:formRemote>
</div>
%{--<g:submitButton name="vasya" value="vasya" onclick="postTreeData()"/>--}%
%{--<div id="bookDetails"></div>--}%
</body>
</html>