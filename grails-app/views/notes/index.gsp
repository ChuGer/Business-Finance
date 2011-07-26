<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.notes.title"/></title>
  <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript" src="../js/jquery/jquery-ui-1.8.1.min.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-ru.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker-en-US.js"></script>


  <link rel="stylesheet" href="../css/smoothness/jquery-ui-1.8.2.custom.css"/>
  <script type="text/javascript" src="../js/jquery/jquery.dateFormat-1.0.js"></script>
  <script type="text/javascript" src="../js/jquery/jquery.ui.datepicker.js"></script>
  %{--<link rel="stylesheet" media="screen" type="text/css" href="../css/layout.css"/>--}%
  <style type="text/css">
  .editNoteBtn {
    width: 24px;
    background-image: url('../images/tree/pencil--exclamation.png');
    background-repeat: no-repeat;
    display: none;
    text-indent: -300px;
  }

  .commonNote {
    background: #ffffff; /* Old browsers */
    background: -moz-linear-gradient(top, #ffffff 0%, #e5e5e5 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #ffffff), color-stop(100%, #e5e5e5)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #ffffff 0%, #e5e5e5 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #ffffff 0%, #e5e5e5 100%); /* Opera11.10+ */
    background: -ms-linear-gradient(top, #ffffff 0%, #e5e5e5 100%); /* IE10+ */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr = '#ffffff', endColorstr = '#e5e5e5', GradientType = 0); /* IE6-9 */
    background: linear-gradient(top, #ffffff 0%, #e5e5e5 100%); /* W3C */
  }

  .importantNote {
    background: #ffc578; /* Old browsers */
    background: -moz-linear-gradient(top, #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #ffc578), color-stop(100%, #fb9d23)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #ffc578 0%, #fb9d23 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #ffc578 0%, #fb9d23 100%); /* Opera11.10+ */
    background: -ms-linear-gradient(top, #ffc578 0%, #fb9d23 100%); /* IE10+ */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr = '#ffc578', endColorstr = '#fb9d23', GradientType = 0); /* IE6-9 */
    background: linear-gradient(top, #ffc578 0%, #fb9d23 100%); /* W3C */
  }

  #notesTable.ajax tbody tr td {
    font-style:italic;
    text-align: center;
    vertical-align: middle;
  }

  #notesTable.ajax tbody tr {
    height: 30px;
    padding: 3px;
  }

  #notesTable.ajax tbody tr:hover {
    background: none repeat scroll 0 0 #D0DAFD;
    color: #333399;
  }
  </style>
  <script type="text/javascript">



    var isSingleCreatingMode = false;
    $(function() {
      createDialog();
      $.getJSON("locale", function(json) {
        regional = $.datepicker.regional[json.locale];
        $("#endDate").datepicker(regional);
      });
      setupGridAjax();
      bindCreateButtons();
    });
    function ctgClick(id) {
      jQuery.ajax({
        url: 'categorySelect',
        type: "POST",
        data: {id: id},
        dataType: "json",
        complete: function(data) {
          $('#notesHolder').html(data.responseText);
        }
      }
              );
    }

    function bindCtgClickEvent(id) {
      console.log('clikedBB ');
      $('#ctgNote' + id).click(function() {
        console.log('cliked ' + id);
        ctgClick(id);
      });
    }
    function closeNoteDialog() {
      $("#note-form").dialog("close");
      if (isSingleCreatingMode) {
        $("input[name=_action_saveNote]").css({display: "inline-block"});
        $("input[name=_action_deleteNote]").css({display: "inline-block"});
        isSingleCreatingMode = false;
      }
    }

    function bindNoteClickEvent(id) {
      console.log('clikednn ');
      $('#e' + id).click(function() {
        console.log('cliked note ' + id);
        jQuery.ajax({
          url: 'getNode',
          type: "POST",
          data: {id: id},
          dataType: "json",
          complete: function(data, textStatus) {
            var obj = jQuery.parseJSON(data.responseText)
            $('#noteName').val(obj.name);
            $('#noteValue').val(obj.value);
            $('#noteId').val(obj.id);
            if (String(obj.date) == 'null')
              $("#endDate").val('');
            else
              $("#endDate").val($.format.date(new Date(obj.date), "dd/MM/yyyy"));

            $('input[name=isMade]').attr('checked', obj.isMade);

            $("input[name=_isMade]").attr('value', obj.isMade);
            $("input[name=_isImportant]").attr('value', obj.isImportant);


            $("select#ctnId").val(obj.ctg);
            $('input[name=isImportant]').attr('checked', obj.isImportant);
            $("#note-form").dialog("open");

          }
        }
                );
      });
    }
    function bindCreateButtons() {
      $("#addNote").click(function() {
        $('#noteName').val('');
        $('#noteValue').val('');
        $('#noteId').val('');
        $("#endDate").val('');

        $('input[name=isMade]').attr('checked', false);
        $("input[name=_isMade]").attr('value', 'false');
        $("input[name=_isImportant]").attr('value', 'false');
        $("select#ctnId").val('');
        $('input[name=isImportant]').attr('checked', false);

        $("input[name=_action_saveNote]").css({display: "none"});
        $("input[name=_action_deleteNote]").css({display: "none"});
        isSingleCreatingMode = true;
        $("#note-form").dialog("open");
      });
      $("#addCtn").click(function() {
        $("#noteCtgForm").dialog("open");
      });

    }
    function createDialog() {
      $.getJSON("locale", function(json) {
        regional = $.datepicker.regional[json.locale];
        $("#startDate").datepicker(regional);
      });

      $("#note-form").dialog({
        autoOpen: false,
        height: 400,
        width: 350,
        modal: true
      });
      $("#noteCtgForm").dialog({
        autoOpen: false,
        height: 200,
        width: 350,
        modal: true
      });

      $("input[name=_action_addNote]").click(function() {
        $("#actName").val('add');
      });
      $("input[name=_action_saveNote]").click(function() {
        $("#actName").val('save');
      });
      $("input[name=_action_deleteNote]").click(function() {
        $("#actName").val('del');
      });
//      $("#note-form").dialog("open");
    }

    function closeDialog() {
      $("#note-form").dialog("close");
      $("#name").val('');
    }
    function showDialog() {
      $("#note-form").dialog("open");
    }
    function noteLineHoverIn(id) {
      $("#e" + id).animate().css({display: "inline-block"});
    }
    function noteLineHoverOut(id) {
      $("#e" + id).animate().css({display: "none"});
    }

    function triggerIsMade() {
      var obj = $("input[name=_isMade]");
      var value = String(obj.attr('value'));

      if (value == "true")
        obj.attr('value', 'false');
      else
        obj.attr('value', 'true');
    }
    function triggerIsImp() {
      var obj = $("input[name=_isImportant]");
      var value = String(obj.attr('value'));

      if (value == "true")
        obj.attr('value', 'false');
      else
        obj.attr('value', 'true');
    }
    function triggerAjaxIsMade(id) {
      jQuery.ajax({
        url: 'isMadeTrigger',
        type: "POST",
        data: {id: id},
        dataType: "json"
      }
              );
    }
    // Turn all sorting and paging links into ajax requests for the grid
    function setupGridAjax() {
      $("#notesHolder").find(".paginateButtons a, th.sortable a").live('click', function(event) {
        event.preventDefault();
        var url = $(this).attr('href');

        var grid = $(this).parents("table.ajax");
        $(grid).html($("#spinner").html());

        $.ajax({
          type: 'GET',
          url: url,
          success: function(data) {
            $(grid).fadeOut('fast', function() {
              $(this).html(data).fadeIn('slow');
            });
          }
        })
      });
    }

  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.notes.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>


  <div id="categoriesHolder" class="ctnHolder" style="float:left;">
    <g:each in="${categories}" var="ctgNote" status="i">
      <div id="ctgNote${ctgNote.id}" style="padding:7px; font-size:16px; background-color:#f5f5dc; border-radius:5px; margin:10px;">${ctgNote.name}</div>
      <script type="text/javascript">
        bindCtgClickEvent(${ctgNote.id});
      </script>
    </g:each>
    <input type="button" id="addCtn" value="${message(code: "note.button.addCtn", default: 'addCtn')}"/>

  </div>
  <div style="display:inline-block;">
    <input type="button" id="addNote" value="${message(code: "note.button.addNote", default: 'addNote')}"/>
    <div id="notesHolder" class="notesInfo">
      <g:render template="noteslist" model="model"/>
    </div>
  </div>
</div>

<div id="noteFormHolder"><g:render template="note" bean="${noteInstance}"/></div>
<g:render template="addCtn" bean="${ctnInstance}"/>
</body>
</html>

