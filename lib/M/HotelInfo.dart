import 'package:json_annotation/json_annotation.dart';

part 'HotelInfo.g.dart';

@JsonSerializable()
class HotelInfo {
  // int code;  //这个标注是将后台返回的key转成我们自己想要的key
  String? hotelUserName;
  String? hotelAccount;

  HotelInfo(this.hotelUserName, this.hotelAccount);

//JSON转模型的方法
  factory HotelInfo.fromJson(Map<String, dynamic> json) =>
      _$HotelInfoFromJson(json);
//模型转JSON的方法
  Map<String, dynamic> toJson() => _$HotelInfoToJson(this);
}