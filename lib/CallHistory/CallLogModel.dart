import 'Records.dart';

class CallLogModel {
  List<Records>? records;
  int? total;
  int? size;
  int? current;
  bool? optimizeCountSql;
  bool? hitCount;
  int? countId;
  int? maxLimit;
  bool? searchCount;
  int? pages;

  CallLogModel(
      {this.records,
        this.total,
        this.size,
        this.current,
        this.optimizeCountSql,
        this.hitCount,
        this.countId,
        this.maxLimit,
        this.searchCount,
        this.pages});

  CallLogModel.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
    total = json['total'];
    size = json['size'];
    current = json['current'];

    optimizeCountSql = json['optimizeCountSql'];
    hitCount = json['hitCount'];
    countId = json['countId'];
    maxLimit = json['maxLimit'];
    searchCount = json['searchCount'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['size'] = this.size;
    data['current'] = this.current;

    data['optimizeCountSql'] = this.optimizeCountSql;
    data['hitCount'] = this.hitCount;
    data['countId'] = this.countId;
    data['maxLimit'] = this.maxLimit;
    data['searchCount'] = this.searchCount;
    data['pages'] = this.pages;
    return data;
  }
}