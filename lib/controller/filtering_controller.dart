import 'package:get/get.dart';

class FilteringController extends GetxController {
  String selectedTransactionType = '';
  bool? selectedTrading;
double? selectedPromotion;
String? todayDateFilter; 
String? dateFilter; 
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
    todayDateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setYesterdayDate(String? value) {
   todayDateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setWeekAgoDate(String? value) {
   dateFilter = value!;
    update(); // This will rebuild the UI
  }
  void setMonthAgoDate(String? value) {
    dateFilter = value!;
    update(); // This will rebuild the UI
  }
void clearFilters() {
    selectedTransactionType = ''; // Reset to 'All'
    selectedTrading = null;
    selectedPromotion = null;
    todayDateFilter = null;
    dateFilter = null;
    selectedFromDate = null;
    selectedToDate = null;
  }
  
}

