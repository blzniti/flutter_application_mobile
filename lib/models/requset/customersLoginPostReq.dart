// customersLoginPostReq.dart
import 'dart:convert';

CustomersLoginPostReq customersLoginPostReqFromJson(String str) => CustomersLoginPostReq.fromJson(json.decode(str));

String customersLoginPostReqToJson(CustomersLoginPostReq data) => json.encode(data.toJson());

class CustomersLoginPostReq {
  String phone;
  String password;

  CustomersLoginPostReq({
    required this.phone,
    required this.password,
  });

  factory CustomersLoginPostReq.fromJson(Map<String, dynamic> json) => CustomersLoginPostReq(
    phone: json["phone"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "password": password,
  };
}
