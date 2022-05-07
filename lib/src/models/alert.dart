class Alert {
  Alert({
    required this.tokenName,
    required this.compareTo,
    required this.compareBy,
    required this.target,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      tokenName: json["tokenName"],
      compareTo: json["compareTo"],
      compareBy: json['compareBy'],
      target: json['target'],
    );
  }

  final String tokenName;
  final String compareTo;
  final String compareBy;
  final num target;

  Map<String, Object?> toJson() {
    return {
      "tokenName": tokenName,
      "compareTo": compareTo,
      "compareBy": compareBy,
      "target": target,
    };
  }
}
