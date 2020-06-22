import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
    this.id,
    this.type,
    this.value,
  });

  int id;
  ScanType type;
  String value;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        type: EnumToString.fromString(ScanType.values, json["type"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": EnumToString.parse(type),
        "value": value,
      };
}

enum ScanType { GEO, LINK }
