
class MqttMsgModel {
  String? msg;
  String? type;
  Data? data;

  MqttMsgModel({this.msg,
        this.type,
        this.data,});

  MqttMsgModel.fromJson(json){
    msg = json['msg'].toString();
    type = json['type'].toString();

    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? id;
  String? status;
  String? roomNumber;

  Data({this.id,this.status, this.roomNumber});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    status = json['status'];
    roomNumber = json['roomNumber'];
  }
}