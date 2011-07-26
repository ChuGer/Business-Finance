<%@ page import="domain.Note" %>
<table id="notesTable" width="140px"  class="ajax">
  <thead>
  <tr>

    <g:sortableColumn property="name" action="index" title="${message(code: 'note.name', default: 'name')}"/>

    <th><g:message code="note.value" default="value"/></th>

    <g:sortableColumn property="endDate"   action="index" title="${message(code: 'note.endDate', default: 'endDate')}"/>

    <th ><g:message code="note.isMade" default="isMade"/></th>
  </tr>
  </thead>
  <tbody>
  <g:each in="${noteList}" var="note" status="i">
    <tr id = "noteRow${note.id}" style="max-width:100" class="${note.isImportant?'importantNote':'commonNote'}" >

      <td id="noteName${i}" valign="top" class="notename" width="22">
          ${note.name}
      </td>
      <td id="noteValue${i}" width="22" valign="top" class="notevalue ${hasErrors(bean: Note, field: 'value', 'errors')}">
         ${note.value[0..16]}..
      </td>
      <td id="noteDate${i}" width="22"  valign="top" class="notedate ${hasErrors(bean: Note, field: 'endDate', 'errors')}">
        <g:if test="${note.endDate}">${note.endDate?.dateString}</g:if>
        <g:else > </g:else>
      </td>
      <td   width="5">
        <g:checkBox id = "isMade${i}" name="isMade${i}" checked="${note.isMade}"
            onclick="triggerAjaxIsMade(${note.id})"/>
        <div id = "e${note.id}" style="display: none; width: 24px;">[e]</div>
      </td>


    </tr>
      <script type="text/javascript">
       bindNoteClickEvent(${note.id});
        $("#noteRow${note.id}").hover(
  function () {
   $("#e"+${note.id}).animate().css({display: "inline-block"});
  },
  function () {
    $("#e"+${note.id}).animate().css({display: "none"});

  }
);
    </script>
  </g:each>

  </tbody>

</table>
<div class="pagination">
    <g:paginate total="${notesTotal}" />
</div>