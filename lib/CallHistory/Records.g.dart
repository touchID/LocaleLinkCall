// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Records _$RecordsFromJson(Map<String, dynamic> json) => Records(
      id: json['id'] as int?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      hotelId: json['hotelId'] as int?,
      callingName: json['callingName'] as String?,
      calledName: json['calledName'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$RecordsToJson(Records instance) => <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'hotelId': instance.hotelId,
      'callingName': instance.callingName,
      'calledName': instance.calledName,
      'status': instance.status,
    };
