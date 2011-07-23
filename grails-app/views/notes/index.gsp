<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="nemain"/>
  <title><g:message code="menu.note.title"/></title>
   <g:javascript library="jquery" plugin="jquery"/>
  <script type="text/javascript">

    $(function() {
      createDialog();
      $('input').daterangepicker({arrows:true});
    });

    function bindClickEvent(id) {
      console.log('clikedBB ' );
      $('#ctgNote' + id).click(function() {
        console.log('cliked '+id);
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
    }

    function closeDialog() {
      $("#note-form").dialog("close");
      $("#name").val('');
    }
    function showDialog() {
      $("#note-form").dialog("open");
    }
  </script>
</head>
<body>
<div class="nav">
</div>
<div class="body">
  <h1><g:message code="menu.note.title"/></h1>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
</div>



<div id="categoriesHolder" class="ctnHolder">

  <g:each in="${categories}" var="ctgNote" status="i"   >

  <div id='ctgNote${i}' > ${ctgNote.name}</div>
    <script type="text/javascript">
       bindClickEvent(${i});
    </script>
  </g:each>

</div>
<div id="notesHolder" class="notesInfo"></div>

</body>
</html>

