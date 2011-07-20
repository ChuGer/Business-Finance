<div id="cto-form" title="<g:message code="ctgo.create"/>">
  <g:hasErrors bean="${ctgOInstance}">
    <div class="errors">
      <g:renderErrors bean="${ctgOInstance}" as="list"/>
    </div>
  </g:hasErrors>
  <g:formRemote name="createCategoryOForm" url="[action: 'addOprCategory']" onSuccess="createCtgOprnode(data,textStatus);" onComplete="closeCtgOprDialog()">
    <div class="dialog">
      <table>
        <tbody>
        <tr class="prop">
          <td valign="top" class="name">
            <label for="ctgO.Name"><g:message code="ctgo.name.label" default="Name"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgBInstance, field: 'name', 'errors')}">
            <g:textField id="ctgO.Name" name="name" value="${ctgOInstance?.name}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="oprPicker"><g:message code="ctgo.color.label" default="Color"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgOInstance, field: 'color', 'errors')}">
            <g:hiddenField id="colorso" name="color" value="${ctgOInstance?.color}"/>
            <div id="oprPicker"></div>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="ctgO.icon"><g:message code="ctgo.ico.label" default="Icon"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: ctgOInstance, field: 'ico', 'errors')}">
            <g:textField id="ctgO.icon" name="ico" value="${ctgOInstance?.ico}"/>
          </td>
        </tr>
        <g:hiddenField id="categoryb3" name="categoryb"/>
        <div class="buttons">
          <span class="button"><g:actionSubmit class="save" action="addBillCategory" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
        </div>
        </tbody>
      </table>
    </div>
  </g:formRemote>
</div>
