
import 'dart:convert';

import '/V/azlistview.dart';


class CityModel extends ISuspensionBean {
  String? id;
  String? name;
  String? tagIndex;
  String? namePinyin;

  CityModel({
    this.id,
    this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}