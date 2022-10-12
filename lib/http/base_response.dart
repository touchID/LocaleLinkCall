import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  //这个标注是将后台返回的key转成我们自己想要的key
  // 后台返回的错误码
  int code;

  // 返回的信息
  String msg;

  var data;

  BaseResponse(this.code, this.msg , this.data);
//JSON转模型的方法
  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
//模型转JSON的方法
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
// D:\code\SDK\flutter_windows_3.3.1-stable\bin
//flutter packages pub run build_runner watch