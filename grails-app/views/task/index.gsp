<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.task.title"/></title>
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
      createStatistics();
      createColor();
      var lastHoveredNodeId = 'd1';
    });

    function createStatistics() {
      jQuery.ajax({
        url: 'renderStat',
        type: "POST",
        dataType: "json",
        complete: function(data) {
          $('#statForm').html(data.responseText);
        }
      });
    }

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
      $("#treeDiv").jstree('create', parentNodeId, 'inside', nodeData[0], false, true);

//      $("#treeDiv").jstree('check_node',($('#' + nodeData[0].attr.id)) );  <option value="1">Operations</option>

      refetchEvents();
    }
    function createCtgOprnode(data, textStatus) {
      var nodeData = data[1];
      $("#treeDiv").jstree('create', '#' + lastHoveredNodeId, 'inside', nodeData[0], false, true);
      createOprCategoryButtons($('#' + nodeData[0].attr.id));
      $("#crOprcid").append("<option value=" + data[0].id + " >" + nodeData[0].data[0].title + "</option>");
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
        var prefix = d.rslt.obj.attr("id").substr(0, 1);
        var pid = d.rslt.obj.attr("id") + "p";
        var pid2 = d.rslt.obj.attr("id") + "f";
        $("#" + pid).animate().css({display: "inline-block"})
        $("#" + pid2).animate().css({display: "inline-block"})
        if (prefix == 'd' || prefix == 'c') {
          lastHoveredNodeId = d.rslt.obj.attr("id");
          $("#categoryb").val(lastHoveredNodeId);
          $("#categoryb2").val(lastHoveredNodeId);
          $("#categoryb3").val(lastHoveredNodeId);
          $("#categoryb4").val(lastHoveredNodeId);
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


      tree.bind("rename.jstree", function(event, data) {
        alert(data.rslt.obj.attr("id") + "  " + data.rslt.new_name + " from " + data.rslt.old_name);
      });

      tree.bind("create.jstree", function(event, data) {
//        alert(data.rslt.obj.attr("id") + "  " + $("#treeDiv").jstree('get_text', '#' + d.rslt.obj.attr("id")));
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
            complete: function(data) {
              $('#statForm').html(data.responseText);
            }
          }
                  );
        }
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
          revertFunc();
        },
        editable: true,
        disableResizing: true,
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
  <h1><g:message code="menu.task.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <div>
    <div id="treeDiv" style="min-width:220px; float :left; margin:10px;"></div>
    <div id="calendar" style="min-width:700px; display: inline-block;margin:10px;"></div>
    <div id="statForm" style="min-width:150px; float: right; background-color:#f5f5f5; border-radius:10px; margin:10px;"></div>
  </div>

  <g:render template="oprForm" bean="${operationInstance}"/>
  <g:render template="bilForm" bean="${billInstance}"/>
  <g:render template="ctoForm" bean="${ctgOInstance}"/>
  <g:render template="ctbForm" bean="${ctgBInstance}"/>

</div>
</body>
</html>

