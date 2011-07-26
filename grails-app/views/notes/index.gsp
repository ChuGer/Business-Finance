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


  </style>
  <script type="text/javascript">



    var isSingleCreatingMode = false;
    var lastClickedCategoryId;
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
      lastClickedCategoryId = id;
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
        $("select#ctnId").val(lastClickedCategoryId);
        $('input[name=isImportant]').attr('checked', false);

        $("input[name=_action_saveNote]").css({display: "none"});
        $("input[name=_action_deleteNote]").css({display: "none"});
        isSingleCreatingMode = true;
        $("#note-form").dialog("open");
      });
      $("#addCtn").click(function() {
        isSingleCreatingMode = true;
        $("#ctnName").val('');
        $("input[name=_action_saveCtn]").css({display: "none"});
        $("input[name=_action_deleteCtn]").css({display: "none"});
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
        modal: true,
        close: function(ev, ui) {
          $("input[name=_action_saveNote]").css({display: "inline-block"});
          $("input[name=_action_deleteNote]").css({display: "inline-block"});
        }
      });
      $("#noteCtgForm").dialog({
        autoOpen: false,
        height: 200,
        width: 350,
        modal: true,
        close: function(ev, ui) {
          $("input[name=_action_saveCtn]").css({display: "inline-block"});
          $("input[name=_action_deleteCtn]").css({display: "inline-block"});
        }
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
    function categoryManage(id,val){
       isSingleCreatingMode = true;
        $("#ctnName").val(val);
        $("#selectedId").val(id);
        $("#noteCtgForm").dialog("open");
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
      <div id="ctgNote${ctgNote.id}" style="padding:7px; font-size:16px; background-color:#f5f5dc;
      border-radius:5px; margin:10px;" ondblclick="categoryManage(${ctgNote.id},'${ctgNote.name}');">${ctgNote.name}</div>
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

