<div id="bill-form" title="<g:message code="bill.create"/>">
   <g:hasErrors bean="${billInstance}">
     <div class="errors">
       <g:renderErrors bean="${billInstance}" as="list"/>
     </div>
   </g:hasErrors>
   <g:formRemote name="createBillForm" url="[action: 'addBill']" onSuccess="createBillnode(data,textStatus);" onComplete="closeBillDialog()">
     <div class="dialog">
       <table>
         <tbody>
         <tr class="prop">
           <td valign="top" class="name">
             <label for="billName"><g:message code="bill.name.label" default="Name"/></label>
           </td>
           <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'name', 'errors')}">
             <g:textField id="billName" name="name" value="${billInstance?.name}"/>
           </td>
         </tr>


         <tr class="prop">
           <td valign="top" class="name">
             <label for="currency"><g:message code="bill.currency.label" default="Currency"/></label>
           </td>
           <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'currency', 'errors')}">
             <g:select name="currency" from="${domain.Currency.list()}" optionKey="id" value="${billInstance?.currency?.id}"/>
           </td>
         </tr>

         <tr class="prop">
           <td valign="top" class="name">
             <label for="balance"><g:message code="bill.balance.label" default="Balance"/></label>
           </td>
           <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'balance', 'errors')}">
             <g:textField id="balance" name="balance" value="${billInstance?.name}"/>
           </td>
         </tr>


         <tr class="prop">
           <td valign="top" class="name">
             <label for="icon"><g:message code="bill.ico.label" default="Icon"/></label>
           </td>
           <td valign="top" class="value ${hasErrors(bean: billInstance, field: 'ico', 'errors')}">
             <g:textField id="icon" name="ico" value="${billInstance?.ico}" readonly="true"/>
           </td>
         </tr>
         <g:hiddenField id="categoryb2" name="categoryb"/>
         <div class="buttons">
           <span class="button"><g:actionSubmit class="save" action="addBill" value="${message(code: 'default.button.save.label', default: 'Save')}"/></span>
         </div>
         </tbody>
       </table>
     </div>
   </g:formRemote>
 </div>
