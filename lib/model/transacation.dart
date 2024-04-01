class TransactionModel {
  final String user;
  final String transactionType;
  final String date;
  final String model;
  final String company;
  final String imei;
  final double? price;
  final double? discount;
  final String? cashOrCredit;
  final String? vendorName;
  final bool? trading;
  final double? promotion;
  final DateTime time;

  TransactionModel({
    required this.user,
    required this.transactionType,
    required this.date,
    required this.model,
    required this.company,
    required this.imei,
    required this.price,
    this.discount,
    this.cashOrCredit,
    this.vendorName,
    this.trading,
    this.promotion,
    required this.time,
  });

  // Factory constructor to convert Firebase data to TransactionModel
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
        user: map['user'],
        transactionType: map['transactionType'],
        date: map['date'],
        model: map['model'],
        company: map['company'],
        imei: map['imei'],
        price: map['price'],
        discount: map['discount'],
        cashOrCredit: map['cashOrCredit'],
        vendorName: map['vendorName'],
        trading: map['trading'],
        promotion: map['promotion'],
        time: map['time']);
  }

  // Method to convert TransactionModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'transactionType': transactionType,
      'date': date,
      'model': model,
      'company': company,
      'imei': imei,
      'price': price,
      'discount': discount,
      'cashOrCredit': cashOrCredit,
      'vendorName': vendorName,
      'trading': trading,
      'promotion': promotion,
      'time': time
    };
  }
}
