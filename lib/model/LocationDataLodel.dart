// To parse this JSON data, do
//
//     final locationDataModel = locationDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LocationDataModel> locationDataModelFromJson(String str) => List<LocationDataModel>.from(json.decode(str).map((x) => LocationDataModel.fromJson(x)));

String locationDataModelToJson(List<LocationDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationDataModel {
    LocationDataModel({
        required this.latitude,
        required this.longitude,
        required this.createdAt,
    });

    dynamic latitude;
    dynamic longitude;
    DateTime createdAt;

    factory LocationDataModel.fromJson(Map<String, dynamic> json) => LocationDataModel(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
    };
}
