<h1 style="text-align:center;">${stat?.bill?.name}</h1>
<g:message code="main.stat.balance"/>: ${stat?.bill?.balance}<br/><br/>
<table>
  <tr>
    <th><g:message code="main.stat.category.name"/></th>
    <th><g:message code="main.stat.category.income"/></th>
    <th><g:message code="main.stat.category.outcome"/></th>
    <th><g:message code="main.stat.category.result"/></th>
  </tr>
  <g:each in="${stat?.categories}" var="i">
    <tr>
      <td>${i?.categoryName}</td>
      <td>${i?.income}</td>
      <td>${i?.outcome}</td>
      <td>${i?.result}</td>
    </tr>
  </g:each>
  <tr style="background-color:#e6e6fa;">
    <td>${stat?.result?.categoryName}</td>
    <td>${stat?.result?.income}</td>
    <td>${stat?.result?.outcome}</td>
    <td>${stat?.result?.result}</td>
  </tr>
</table>
</div>
