import 'package:json_annotation/json_annotation.dart';
part 'Records.g.dart';

@JsonSerializable()
class Records {
  int? id;
  String? createTime;
  String? updateTime;
  int? hotelId;
  String? callingName;
  String? calledName;
  String? status;

  Records(
      {this.id,
        this.createTime,
        this.updateTime,
        this.hotelId,
        this.callingName,
        this.calledName,
        this.status});
  //JSON转模型的方法
  factory Records.fromJson(Map<String, dynamic> json) =>
      _$RecordsFromJson(json);
//模型转JSON的方法
  Map<String, dynamic> toJson() => _$RecordsToJson(this);
}