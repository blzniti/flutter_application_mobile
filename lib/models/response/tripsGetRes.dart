// To parse this JSON data, do
//
//     final tripsGetResponse = tripsGetResponseFromJson(jsonString);

import 'dart:convert';

List<TripsGetResponse> tripsGetResponseFromJson(String str) => List<TripsGetResponse>.from(json.decode(str).map((x) => TripsGetResponse.fromJson(x)));

String tripsGetResponseToJson(List<TripsGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsGetResponse {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripsGetResponse({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripsGetResponse.fromJson(Map<String, dynamic> json) => TripsGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}
