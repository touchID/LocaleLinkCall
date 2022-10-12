
class RoomModel {
  String? id;
  String? roomNumber;
  String? status;
  String? duerosGateway;
  String? ol;

  RoomModel(
      {this.id,
        this.roomNumber,
        this.status,
        this.duerosGateway,
        this.ol});

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    roomNumber = json['roomNumber'].toString();
    status = json['status'].toString();
    // duerosGateway = json['dueros_gateway'].toString();
    // ol = json['ol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roomNumber'] = this.roomNumber;
    data['status'] = this.status;
    data['dueros_gateway'] = this.duerosGateway;
    data['ol'] = this.ol;
    return data;
  }
}
//{id: 20, createTime: 2022-03-09 16:29:42, updateTime: 2022-03-09 16:29:42, hotelId: 54, roomNumber: 8888, wifiName: null, wifiPwd: null, floor: null, roomDevices: []}