package utils

import domain.Bill

class BillStatCollector {
  Bill bill
  List<BillStatHelper> categories = []
  BillStatHelper result
}
