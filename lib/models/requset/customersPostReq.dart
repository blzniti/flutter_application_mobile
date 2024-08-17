// To parse this JSON data, do
//
//     final customersPostRequest = customersPostRequestFromJson(jsonString);

import 'dart:convert';

CustomersPostRequest customersPostRequestFromJson(String str) => CustomersPostRequest.fromJson(json.decode(str));

String customersPostRequestToJson(CustomersPostRequest data) => json.encode(data.toJson());

class CustomersPostRequest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomersPostRequest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomersPostRequest.fromJson(Map<String, dynamic> json) => CustomersPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
