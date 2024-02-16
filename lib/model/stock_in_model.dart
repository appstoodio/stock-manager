// class StockInModel {
//   final DateTime date;
//   final String model;
//   final String company;
//   final double price;
//   final double? discount;
//   final String imei;

//   StockInModel({
//     required this.date,
//     required this.model,
//     required this.company,
//  required this.imei,
//     required this.price,
//     this.discount,
//   });

//   // Factory constructor to convert Firebase data to StockInModel
//   factory StockInModel.fromMap(Map<String, dynamic> map) {
//     return StockInModel(
//       date: DateTime.parse(map['date']),
//        model: map['model'],
//          company: map['company'],
//       price: map['price'],
//       discount: map['discount'],
//       imei: map['imei'],
//     );
//   }

//   // Method to convert StockInModel to a map for Firebase
//   Map<String, dynamic> toMap() {
//     return {
//       'date': date.toIso8601String(),
//       'model': model,
//       'company': company,
//       'price': price,
//       'discount': discount,
//       'imei': imei,
//     };
//   }
// }
