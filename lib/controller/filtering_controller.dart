import 'package:get/get.dart';

class FilteringController extends GetxController {
  String selectedTransactionType = '';
  bool? selectedTrading;
double? selectedPromotion;
String? todayDateFilter; 
String? dateFilter; 
   RxString selectedFromDate = ''.obs;
  RxString selectedToDate= ''.obs;

  void setSelectedFromDate(String date) {
    selectedFromDate.value = date;
    update(); // Notify UI to rebuild
    print(selectedFromDate.value);
  }

  void setSelectedToDate(String date) {
    selectedToDate.value = date;
    update(); // Notify UI to rebuild
    print(selectedToDate.value);
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
    selectedFromDate.value = '';
    selectedToDate.value = '';
  }
  
}

