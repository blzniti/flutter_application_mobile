// To parse this JSON data, do
//
//     final customersGetResponse = customersGetResponseFromJson(jsonString);

import 'dart:convert';

List<CustomersGetResponse> customersGetResponseFromJson(String str) => List<CustomersGetResponse>.from(json.decode(str).map((x) => CustomersGetResponse.fromJson(x)));

String customersGetResponseToJson(List<CustomersGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomersGetResponse {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomersGetResponse({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomersGetResponse.fromJson(Map<String, dynamic> json) => CustomersGetResponse(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
