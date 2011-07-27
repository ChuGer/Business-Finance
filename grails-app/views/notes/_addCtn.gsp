<%@ page import="domain.CategoryNote" %>


<div id="noteCtgForm" title="<g:message code="note.category.add" default="Category edit"/>">
  <g:form name="noteCtgForm" url="[controller: 'notes', action: 'addCtn']">
    <div class="dialog">
      <table>
        <tbody>
        <tr class="prop">
          <td valign="top" class="name">
            <label for="ctnName"><g:message code="note.name.label" default="Name"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: CategoryNote, field: 'name', 'errors')}">
            <g:textField id="ctnName" name="name" value="${ctnInstance?.name}"/>
          </td>
        </tr>
        <g:hiddenField id="selectedId" name="ctnId"/>
        <div class="buttons">
          <span class="button"><g:actionSubmit class="edit" action="saveCtn" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
          <span class="button"><g:actionSubmit class="save" action="addCtn" value="${message(code: 'default.button.create.label', default: 'Create')}"/></span>
          <span class="button"><g:actionSubmit class="delete" action="deleteCtn" value="${message(code: 'default.button.delete.label', default: '[x]')}"/></span>
        </div>
        </tbody>
      </table>
    </div>
  </g:form>
</div>