
class Article {
  String? id;
  String? roomNumber;
  String? createTime;
  String? number;
  String? unit;
  String? goods;
  String? status;
  String? content;

  Article();

  Article.fromJson(json){
    id = json['id'].toString();
    roomNumber = json['roomNumber'].toString();
    createTime = json['createTime'].toString();
    number = json['number'].toString();
    unit = json['unit'].toString();
    goods = json['goods'].toString();
    status = json['status'].toString();
    content = json['number'].toString()+json['unit'].toString()+json['goods'].toString();
  }
}