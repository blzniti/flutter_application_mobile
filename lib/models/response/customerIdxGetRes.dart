// To parse this JSON data, do
//
//     final customerIdxGetResponse = customerIdxGetResponseFromJson(jsonString);

import 'dart:convert';

CustomerIdxGetResponse customerIdxGetResponseFromJson(String str) => CustomerIdxGetResponse.fromJson(json.decode(str));

String customerIdxGetResponseToJson(CustomerIdxGetResponse data) => json.encode(data.toJson());

class CustomerIdxGetResponse {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomerIdxGetResponse({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomerIdxGetResponse.fromJson(Map<String, dynamic> json) => CustomerIdxGetResponse(
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
