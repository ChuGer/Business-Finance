package businessfinance

import domain.auth.SecUser
import domain.CategoryOp

class OperationController {
  static navigation = [
          group: 'tabs',
          order: 2,
          title: "operation",
          action: 'index'
  ]

  def springSecurityService

  def index = {
    SecUser user = springSecurityService.getCurrentUser()
    if (user) {
      def rootCat = user.categoriesO
//      recursiveRemoveOps(rootCat)
      [rootCat: rootCat]
    }
  }

  def recursiveRemoveOps(CategoryOp rootCat) {
    rootCat.categories.each {c ->
      c.operations.each {o ->
        if (o.type != 1) {
          c.removeFromOperations(o)
          println 'remove op' + o
        }
      }
      c.categories.each {ch ->
        recursiveRemoveOps(ch)
      }
    }
  }
}
