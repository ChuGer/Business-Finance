<%--
  Created by IntelliJ IDEA.
  User: Acer5740
  Date: 11.07.11
  Time: 17:44
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Simple GSP page</title>
  <script type="text/javascript" src="../js/jquery/jquery-1.4.2.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/full-calendar/fullcalendar.min.js"></script>
  <link rel="stylesheet" href="../css/fullcalendar.css"/>
  <link rel="stylesheet" href="../css/ui-lightness/jquery-ui-1.8.11.custom.css"/>
  <script type="text/javascript">
    $(document).ready(function() {
      var date = new Date();
      var d = date.getDate();
      var m = date.getMonth();
      var y = date.getFullYear();
      var calendar = $('#calendar').fullCalendar({
        header: {
          left: 'prev,next today',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {
          $("#dialog").dialog({modal: true});
          var title = prompt('Event Title:');
          if (title) {
            calendar.fullCalendar('renderEvent',
            {
              title: title,
              start: start,
              end: end,
              allDay: allDay
            },
                    true // make the event "stick"
                    );
          }
          calendar.fullCalendar('unselect');
        },
        editable: true,
        events: 'events'
      });
    });
    var jsonObjects = [
      {id:1, name:"amit"},
      {id:2, name:"ankit"},
      {id:3, name:"atin"},
      {id:1, name:"puneet"}
    ];
    function postTreeData() {
      $.ajax({
        type: "POST",
        url: "savedata",
        contentType : "text/plain",
        dataType: 'json',
        data: JSON.stringify(jsonObjects),
        beforeSend: function(x) {
          if (x && x.overrideMimeType) {
            x.overrideMimeType("application/json;charset=UTF-8");
          }
        },
        complete: function(jqXHR, textStatus) {
          if (jqXHR.readyState === 4) {
            alert(textStatus);
          }
        },
        success: function(result) {
          alert(result);
        }
      });
    }

  </script>
</head>
<body>Place your content here

<div style="width:1000px;" id="calendar">

  <g:submitButton name="vasya" value="vasya" onclick="postTreeData()"/>
  <div id="dialog" title="Basic dialog">
    <form>
      <input value="text input"><br>
      <input type="checkbox">checkbox<br>
      <input type="radio">radio<br>
      <select>
        <option>select</option>
      </select><br><br>
      <textarea>textarea</textarea><br>
    </form>
  </div>

</div>
</body>
</html>