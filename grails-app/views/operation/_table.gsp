<table id="operationTable">
  <tr>
    <th><h2><g:message code="operation.name.label"/></h2></th>
    <th><h2><g:message code="operation.sum.label"/></h2></th>
    <th><h2><g:message code="operation.startDate.label"/></h2></th>
  </tr>

  <g:each in="${rootCat.operations}" var="rio">
    <tr>
      <td>${rio.name}</td>
      <td>${rio.sum}</td>
      <td><g:formatDate date="${rio.startDate}" format="dd/MM/yyyy"/></td>
    </tr>
  </g:each>

  <g:each in="${rootCat.categories}" var="i">
    <tr>
      <th style="background: ${i.color}; color: white;">
        <h3>${i.name}</h3>
      </th>
    </tr>
    <g:each in="${i.operations}" var="io">
      <tr>
        <td>${io.name}</td>
        <td>${io.sum}</td>
        <td><g:formatDate date="${io.startDate}" format="dd/MM/yyyy"/></td>
      </tr>
    </g:each>

    <g:each in="${i.categories}" var="ic">
      <tr>
        <th style="background: ${ic.color}; color: white;"><g:message code="all.space.formatter"/>${ic.name}</th>
      </tr>
      <g:each in="${i.operations}" var="ioi">
        <tr>
        <tr>
          <td><g:message code="all.space.formatter"/>${ioi.name}</td>
          <td>${ioi.sum}</td>
          <td><g:formatDate date="${io.startDate}" format="dd/MM/yyyy"/></td>
        </tr>
      </g:each>
    </g:each>
  </g:each>
</table>
