
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '消息/chatList.dart';
import '门/qr/qrCode.dart';
import 'M/city_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

///关于一些常用的工具
class Utils {
  static String ANDROID_UUID = "";

  Utils.init(){
    // getPlatformUUID().then((value){
    //   ANDROID_UUID = value;
    // });
    getPlatformUUID();
  }
  static getPlatformUUID() async {
    try {
      String? identifier = 'A2420C04-02E8-4937-A136-720F14B081A9';
      if (Platform.isAndroid) {//UUID for Android
        identifier = await PlatformDeviceId.getDeviceId;
        print('androidId: <$identifier>');
        var uuid = Uuid();
        identifier = uuid.v5(Uuid.NAMESPACE_URL, identifier);
        print('android_uuId: <$identifier>');
      }
      ANDROID_UUID = identifier;
    } catch (e) {
    }
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    if (tag == '★') {
      tag = '★ 最近入住';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag == '★ 最近入住' ? '★ 最近入住' :'F$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static checkSeleted(List<CityModel> seletedArray, CityModel model) {
    for (CityModel cityModel in seletedArray) {
      if (model.id == cityModel.id) {
        return true;
      }
    }
    return false;
  }

  static pushVC2(BuildContext context , CityModel model){
    print(model.id);
    if (model.id == null) {
      Fluttertoast.showToast(
          msg: "房间id不存在",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListPage(model.id,model.name)
    ));
  }

  static Widget getListItem(BuildContext context, CityModel model, int type) {
    return Container(
        child: Column(
            children: [
              ListTile(
                title: Text('房间${model.name!}',
                    style: TextStyle(fontSize: 16.0, color: Colors.black)),
                onTap: () {
                  // Navigator.pop(context, model.name);
                  pushVC1(context, model, type);
                },
                trailing: Container(
                  child: Text(type == 1 ? '获取二维码     ' : '发送     ',
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
              Divider(
                height: 0,
              )
            ]));
  }

  static pushVC1(BuildContext context, CityModel model, int type) {
    print(model.id);
    if (model.id == null) {
      Fluttertoast.showToast(
          msg: "房间id不存在",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (type == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QrCodePage(model.id, model.name)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatListPage(model.id, model.name)));
    }
  }
  //
  // static Future<Null> delDir(FileSystemEntity file) async {
  //   if (file is Directory && file.existsSync()) {
  //     print(file.path);
  //     final List<FileSystemEntity> children =
  //     file.listSync(recursive: true, followLinks: true);
  //     for (final FileSystemEntity child in children) {
  //       await delDir(child);
  //     }
  //   }
  //   try {
  //     if (file.existsSync()) {
  //       await file.delete(recursive: true);
  //     }
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  //循环获取缓存大小
  static Future getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    //  File

    if (file is File && file.existsSync()) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory && file.existsSync()) {
      List children = file.listSync();
      double total = 0;
      if (children.length > 0)
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  //格式化文件大小
  static String renderSize(value) {
    if (value == null) {
      return '0.0';
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

}