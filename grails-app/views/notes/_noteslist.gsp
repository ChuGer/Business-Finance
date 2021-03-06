<%@ page import="domain.Note" %>
<table id="notesTable" width="140px" class="ajax">
  <thead>
  <tr>
    <g:sortableColumn property="name" action="index" title="${message(code: 'note.name.label', default: 'name')}"/>
    <th><g:message code="note.value.label" default="value"/></th>
    <g:sortableColumn property="endDate" action="index" title="${message(code: 'note.endDate.label', default: 'endDate')}"/>
    <th><g:message code="note.isMade.label" default="isMade"/></th>
  </tr>
  </thead>
  <tbody>
  <g:each in="${noteList}" var="note" status="i">
    <tr id="noteRow${note.id}" style="max-width:100" class="${note.isImportant ? 'importantNote' : 'commonNote'}">

      <td id="noteName${i}" valign="top" class="notename" style="min-width:150px;">
        ${note.name}
      </td>
      <td id="noteValue${i}" valign="top" class="notevalue ${hasErrors(bean: Note, field: 'value', 'errors')}" style="min-width:250px;">
         ${note.value.length() >16 ? note.value[0..16]+'..' : note.value }
      </td>
      <td id="noteDate${i}" valign="top" class="notedate ${hasErrors(bean: Note, field: 'endDate', 'errors')}" style="min-width:100px;">
        <g:if test="${note.endDate}">${note.endDate?.dateString}</g:if>
        <g:else></g:else>
      </td>
      <td style="min-width:50px;">
        <g:checkBox id="isMade${i}" name="isMade${i}" checked="${note.isMade}" onclick="triggerAjaxIsMade(${note.id})"/>
      </td>
      <td >
        <div id="e${note.id}" style="background:none;display: none; width: 24px;"><img src="../images/pencil.png" alt="[e]"></div>
      </td>

    </tr>
    <script type="text/javascript">
      bindNoteClickEvent(${note.id});
      $("#noteRow${note.id}").hover(function () {
        $("#e" +${note.id}).animate().css({display: "inline-block"});
      }, function () {
        $("#e" +${note.id}).animate().css({display: "none"});
      });
    </script>
  </g:each>

  </tbody>

</table>
  <div class="pagination">
      <g:paginate total="${notesTotal}" action="index" prev="&nbsp" next="&nbsp"/>
    </div>
