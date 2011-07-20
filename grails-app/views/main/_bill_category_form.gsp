<div id="ctb-form" title="<g:message code="ctgb.create"/>">
  <g:hasErrors bean="${ctgBInstance}">
    <div class="errors">
      <g:renderErrors bean="${ctgBInstance}" as="list"/>
    </div>
  </g:hasErrors>
  <g:formRemote name="createCategoryBForm" url="[action: 'addBillCategory']" onSuccess="createCtgBillnode(data,textStatus);" onComplete="closeCtgBillDialog();">
    <div class="dialog">
      <table>
        <tbody>
        <tr class="prop">
          <td valign="top" class="name">
            <label for="billName"><g:message code="ctgb.name.label" default="Name"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'name', 'errors')}">
            <g:textField id="billName" name="name" value="${ctgBInstance?.name}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="bilPicker"><g:message code="ctgb.color.label" default="Color"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'color', 'errors')}">
            <g:hiddenField id="colorsb" name="color" value="${ctgOInstance?.color}"/>
            <div id="bilPicker"></div>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="icon"><g:message code="ctgb.ico.label" default="Icon"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'ico', 'errors')}">
            <g:textField id="icon" name="ico" value="${ctgBInstance?.ico}" readonly="true"/>
          </td>
        </tr>
        <g:hiddenField id="categoryb" name="categoryb"/>
        <div class="buttons">
          <span class="button"><g:actionSubmit class="save" action="addBillCategory" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
        </div>
        </tbody>
      </table>
    </div>
  </g:formRemote>
</div>
