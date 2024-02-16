import 'package:get/get.dart';

class FilteringController extends GetxController {
  String selectedTransactionType = '';
  bool? selectedTrading;
double? selectedPromotion;
String? selectedDateFilter; 
   String? selectedFromDate;
  String? selectedToDate;

  void setSelectedFromDate(String? date) {
    selectedFromDate = date;
    update(); // Notify UI to rebuild
  }

  void setSelectedToDate(String? date) {
    selectedToDate = date;
    update(); // Notify UI to rebuild
  }

  
  void setSelectedTransactionType(String value) {
    selectedTransactionType = value;
    update(); // This will rebuild the UI
  }
  void setSelectedTrading(bool? value) {
    selectedTrading = value;
    update(); // This will rebuild the UI
  }
   void setSelectedPromotion(double? value) {
    selectedPromotion = value;
    update(); // This will rebuild the UI
  }
  void setTodayDate(String? value) {
    selectedDateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setYesterdayDate(String? value) {
   selectedDateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setWeekAgoDate(String? value) {
   selectedDateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setMonthAgoDate(String? value) {
    selectedDateFilter = value!;
    update(); // This will rebuild the UI
  }
void clearFilters() {
    selectedTransactionType = ''; // Reset to 'All'
    selectedTrading = null;
    selectedPromotion = null;
    selectedDateFilter = null;
    selectedFromDate = null;
    selectedToDate = null;
  }
  
}

