
// class StockOutModel {
//   final DateTime date;
//   final String model;
//   final String company;
//   final int imei;
//   final double price;
//   final String cashOrCredit;
//   final String? vendorName;
//   final bool trading;

//   StockOutModel({
//     required this.date,
//     required this.model,
//     required this.company,
//     required this.imei,
//     required this.price,
//     required this.cashOrCredit,
//     this.vendorName,
//     required this.trading
//   });

//   // Factory constructor to convert Firebase data to StockInModel
//   factory StockOutModel.fromMap(Map<String, dynamic> map) {
//     return StockOutModel(
//       date: DateTime.parse(map['date']),
//        model: map['model'],
//          company: map['company'],
//       imei: map['imei'],
//       price: map['price'],
//       cashOrCredit: map['cashorcredit'],
//       vendorName: map['vendorName'],
//       trading: map['trading'],
//     );
//   }

//   //  factory StockOutModel.fromMap(Map<String, dynamic> map) {
//   //   return StockOutModel(
//   //     date: DateTime.parse(map['date']),
//   //      model: map['model'],
//   //        company: map['company'],
//   //     imei: map['imei'],
//   //     price: map['price'],
//   //     cashOrCredit: map['cashorcredit'],
//   //     vendorName: map['vendorName'],
//   //     trading: map['trading'],
//   //   );
//   // }

//   // Method to convert StockInModel to a map for Firebase
//   Map<String, dynamic> toMap() {
//     return {
//       'date': date.toIso8601String(),
//       'model': model,
//       'company': company,
//       'imei': imei,
//       'price': price,
//       'cashOrCredit': cashOrCredit,
//       'vendorName': vendorName,
//       'trading': trading,
//     };
//   }
// }
