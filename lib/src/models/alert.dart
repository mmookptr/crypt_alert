class Alert {
  Alert({
    required this.tokenName,
    required this.compareTo,
    required this.compareBy,
    required this.compareValue,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      tokenName: json["tokenName"],
      compareTo: json["compareTo"],
      compareBy: json['compareBy'],
      compareValue: json['compareValue'],
    );
  }

  late String? id;
  bool isConditionMatched = false;
  final String tokenName;
  final String compareTo;
  final String compareBy;
  final num compareValue;

  Map<String, Object?> toJson() {
    return {
      "tokenName": tokenName,
      "compareTo": compareTo,
      "compareBy": compareBy,
      "compareValue": compareValue,
    };
  }
}
