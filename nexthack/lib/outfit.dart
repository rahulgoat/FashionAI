// To parse this JSON data, do
//
//     final outfit = outfitFromJson(jsonString);

import 'dart:convert';

List<Outfit> outfitFromJson(String str) =>
    List<Outfit>.from(json.decode(str).map((x) => Outfit.fromJson(x)));

String outfitToJson(List<Outfit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Outfit {
  String? outfitName1;
  String description;
  String styleReason;
  String top;
  String bottom;
  String shoes;
  String accessories;
  String? outfitName2;
  String? outfitName3;

  Outfit({
    this.outfitName1,
    required this.description,
    required this.styleReason,
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.accessories,
    this.outfitName2,
    this.outfitName3,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) => Outfit(
        outfitName1: json["Outfit_name_1"],
        description: json["description"],
        styleReason: json["style_reason"],
        top: json["top"],
        bottom: json["bottom"],
        shoes: json["shoes"],
        accessories: json["accessories"],
        outfitName2: json["Outfit_name_2"],
        outfitName3: json["Outfit_name_3"],
      );

  Map<String, dynamic> toJson() => {
        "Outfit_name_1": outfitName1,
        "description": description,
        "style_reason": styleReason,
        "top": top,
        "bottom": bottom,
        "shoes": shoes,
        "accessories": accessories,
        "Outfit_name_2": outfitName2,
        "Outfit_name_3": outfitName3,
      };
}
