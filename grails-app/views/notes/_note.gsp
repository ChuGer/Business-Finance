<div id="note-form">

  <g:formRemote name="noteForm" url="[controller: 'notes', action: 'manageNote']" onSuccess="ctgClick(data.cId)" onComplete="closeNoteDialog();">
    <div class="dialog">
      <table>
        <tbody>
        <tr class="prop">
          <td valign="top" class="name">
            <label for="noteName"><g:message code="note.name.label" default="Name"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'name', 'errors')}">
            <g:textField id="noteName" name="name" value="${noteInstance?.name}"/>
          </td>
        </tr>


        <tr class="prop">
          <td valign="top" class="name">
            <label for="value"><g:message code="note.value.label" default="Text"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'value', 'errors')}">
            <g:textArea cols="10" rows="5" name="value" id="noteValue" value="${noteInstance?.value}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="isImportant"><g:message code="operation.isImportant" default="isImportant"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'isImportant', 'errors')}">
            <g:checkBox id= "isImportant" name="isImportant" value="true" checked="${noteInstance.isImportant}"
            onclick="triggerIsImp()"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="category.id"><g:message code="note.category.label" default="Category"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'category', 'errors')}">
            <g:select id="ctnId" name="category.id" from="${domain.CategoryNote.list()}" optionKey="id"/>
          </td>
        </tr>

         <tr class="prop">
            <td valign="top" class="name">
              <label for="endDate"><g:message code="note.endDate.label" default="EndDate"/></label>
            </td>
            <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'endDate', 'errors')}">
              <g:textField name="endDate" id="endDate"  value="${noteInstance.endDate?.dateString}"/>
            </td>
          </tr>


        <tr class="prop">
          <td valign="top" class="name">
            <label for="isMade"><g:message code="note.isMade" default="isMade"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: noteInstance, field: 'isMade', 'errors')}">
            <g:checkBox id = "isMade" name="isMade" value="true" checked="${noteInstance.isMade}"
            onclick="triggerIsMade()"/>
          </td>
        </tr>

        <g:hiddenField id="noteId" name="noteId"/>
        <g:hiddenField id="actName" name="actName"/>

        <div class="buttons">
          <span class="button"><g:actionSubmit class="save" action="saveNote" value="saveNote"/></span>
          <span class="button"><g:actionSubmit class="create" action="addNote" value="${message(code: 'default.button.create.label', default: 'Create')}"/></span>
          <span class="button"><g:actionSubmit class="delete" action="deleteNote" value="${message(code: 'default.button.delete.label', default: '[x]')}"/></span>
        </div>
        </tbody>
      </table>
    </div>
  </g:formRemote>
</div>