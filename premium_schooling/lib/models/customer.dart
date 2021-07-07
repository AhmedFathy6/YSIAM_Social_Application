/// clientName : "Abanoub Halim"
/// phoneNumber : "01280268998"
/// cardNumber : "1010063200038200"
/// employer : "Premium Card"

class Customer {
  String? clientName;
  String? phoneNumber;
  String? cardNumber;
  String? employer;

  Customer({this.clientName, this.phoneNumber, this.cardNumber, this.employer});

  Customer.fromJson(dynamic json) {
    clientName = json["clientName"];
    phoneNumber = json["phoneNumber"];
    cardNumber = json["cardNumber"];
    employer = json["employer"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["clientName"] = clientName;
    map["phoneNumber"] = phoneNumber;
    map["cardNumber"] = cardNumber;
    map["employer"] = employer;
    return map;
  }
}
