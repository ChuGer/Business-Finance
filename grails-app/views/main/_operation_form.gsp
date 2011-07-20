<div id="opr-form" title="<g:message code="operation.create"/>">
  <g:hasErrors bean="${operationInstance}">
    <div class="errors">
      <g:renderErrors bean="${operationInstance}" as="list"/>
    </div>
  </g:hasErrors>
  <g:formRemote name="createForm" method="post" url="[action: 'addEvent']" onSuccess="createOprnode(data,textStatus);" onComplete="closeDialog();">
    <div class="dialog">
      <table>
        <tbody>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="name"><g:message code="operation.name.label" default="Name"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'name', 'errors')}">
            <g:textField name="name" value="${operationInstance?.name}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="bill.id"><g:message code="operation.bill.label" default="Bill"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'bill', 'errors')}">
            <g:select name="bill.id" from="${domain.Bill.list()}" optionKey="id" value="${operationInstance?.bill?.id}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="sum"><g:message code="operation.sum.label" default="Sum"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'sum', 'errors')}">
            <g:textField name="sum" value="${fieldValue(bean: operationInstance, field: 'sum')}"/>
          </td>
        </tr>


        <tr class="prop">
          <td valign="top" class="name">
            <label for="type"><g:message code="operation.type.label" default="Type"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'type', 'errors')}">
            <g:radioGroup name="type" labels="['outcome','income']" values="[0,1]" value="${fieldValue(bean: operationInstance, field: 'type')}">
              <div style="display:inline-block;">
                <p>${it.radio} <g:message code="operation.type.${it.label}"/></p>
              </div>
            </g:radioGroup>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="startDate"><g:message code="operation.startDate.label" default="Start Date"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'startDate', 'errors')}">
            <g:textField name="startDate" id="startDate" precision="day" value="${operationInstance?.startDate}"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="endDate"><g:message code="operation.endDate.label" default="End Date"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'endDate', 'errors')}">
            <g:textField name="endDate" id="endDate" precision="day" value="${operationInstance?.endDate}" default="none" noSelection="['': '']"/>
          </td>
        </tr>

        <tr class="prop">
          <td valign="top" class="name">
            <label for="category.id"><g:message code="operation.category.label" default="Category"/></label>
          </td>
          <td valign="top" class="value ${hasErrors(bean: operationInstance, field: 'category', 'errors')}">
            <g:select id="crOprcid" name="category.id" from="${domain.CategoryOp.list()}" optionKey="id" value="${operationInstance?.category?.id}"/>
          </td>
        </tr>

        <g:hiddenField id="categoryb4" name="categoryb"/>
        <div class="buttons">
          <span class="button"><g:actionSubmit class="save" action="addEvent" value="${message(code: 'default.button.save.label', default: 'Update')}"/></span>
        </div>
        </tbody>
      </table>
    </div>
  </g:formRemote>
</div>
