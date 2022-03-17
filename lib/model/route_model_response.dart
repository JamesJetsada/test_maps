// To parse this JSON data, do
//
//     final routeModelResponse = routeModelResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RouteModelResponse routeModelResponseFromJson(String str) =>
    RouteModelResponse.fromJson(json.decode(str));

String routeModelResponseToJson(RouteModelResponse data) =>
    json.encode(data.toJson());

class RouteModelResponse {
  RouteModelResponse({
    required this.type,
    required this.features,
    required this.meta,
    required this.data,
  });

  dynamic type;
  List<Feature> features;
  Meta meta;
  Data data;

  factory RouteModelResponse.fromJson(Map<String, dynamic> json) =>
      RouteModelResponse(
        type: json["type"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.fdistance,
    required this.tdistance,
    required this.distance,
    required this.interval,
    required this.penalty,
  });

  double fdistance;
  double tdistance;
  int distance;
  int interval;
  int penalty;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fdistance: json["fdistance"].toDouble(),
        tdistance: json["tdistance"].toDouble(),
        distance: json["distance"],
        interval: json["interval"],
        penalty: json["penalty"],
      );

  Map<String, dynamic> toJson() => {
        "fdistance": fdistance,
        "tdistance": tdistance,
        "distance": distance,
        "interval": interval,
        "penalty": penalty,
      };
}

class Feature {
  Feature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  String type;
  Geometry geometry;
  Properties properties;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "geometry": geometry.toJson(),
        "properties": properties.toJson(),
      };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<List<double>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class Properties {
  Properties({
    required this.turn,
    required this.name,
    required this.distance,
    required this.interval,
  });

  int turn;
  String name;
  int distance;
  int interval;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        turn: json["turn"],
        name: json["name"],
        distance: json["distance"],
        interval: json["interval"],
      );

  Map<String, dynamic> toJson() => {
        "turn": turn,
        "name": name,
        "distance": distance,
        "interval": interval,
      };
}

class Meta {
  Meta({
    required this.from,
    required this.to,
    required this.config,
  });

  From from;
  From to;
  String config;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        from: From.fromJson(json["from"]),
        to: From.fromJson(json["to"]),
        config: json["config"],
      );

  Map<String, dynamic> toJson() => {
        "from": from.toJson(),
        "to": to.toJson(),
        "config": config,
      };
}

class From {
  From({
    required this.lon,
    required this.lat,
  });

  double lon;
  double lat;

  factory From.fromJson(Map<String, dynamic> json) => From(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}
