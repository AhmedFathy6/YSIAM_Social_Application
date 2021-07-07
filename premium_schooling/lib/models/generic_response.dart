import 'package:premium_schooling/models/customer.dart';

/// ResponseTextArabic : null
/// ResponseText : "Invalid mobile Number"
/// ResponseObject : null
/// ResponseCode : 0
/// Status : 1

class GenericResponse {
  String? responseTextArabic;
  String? responseText;
  Customer? responseObject;
  int? responseCode;
  int? status;

  GenericResponse(
      {this.responseTextArabic,
      this.responseText,
      this.responseObject,
      this.responseCode,
      this.status});

  GenericResponse.fromJson(dynamic json) {
    responseTextArabic = json["ResponseTextArabic"];
    responseText = json["ResponseText"];
    if (json["ResponseObject"] != null)
      responseObject = Customer.fromJson(json["ResponseObject"]);
    responseCode = json["ResponseCode"];
    status = json["Status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ResponseTextArabic"] = responseTextArabic;
    map["ResponseText"] = responseText;
    map["ResponseObject"] = responseObject;
    map["ResponseCode"] = responseCode;
    map["Status"] = status;
    return map;
  }
}
