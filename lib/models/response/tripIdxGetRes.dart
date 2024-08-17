// To parse this JSON data, do
//
//     final tripsIdxGetResponse = tripsIdxGetResponseFromJson(jsonString);

import 'dart:convert';

TripsIdxGetResponse tripsIdxGetResponseFromJson(String str) => TripsIdxGetResponse.fromJson(json.decode(str));

String tripsIdxGetResponseToJson(TripsIdxGetResponse data) => json.encode(data.toJson());

class TripsIdxGetResponse {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripsIdxGetResponse({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripsIdxGetResponse.fromJson(Map<String, dynamic> json) => TripsIdxGetResponse(
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
