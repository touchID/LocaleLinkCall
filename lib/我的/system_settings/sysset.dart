import 'dart:io';

import 'package:flutter/material.dart';

import '../../http/pub.dart';
import 'package:path_provider/path_provider.dart';
import '/utils.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class SysSet extends StatefulWidget {
  const SysSet({Key? key}) : super(key: key);

  @override
  State<SysSet> createState() => _SysSetState();
}

class _SysSetState extends State<SysSet> {
  double cache = 0.0;
  String androidUUID = '';

  getSize() async {
    double _cache = 0.0;
    try {
      FileSystemEntity _tempDir = await getTemporaryDirectory();
      _cache = await Utils.getTotalSizeOfFilesInDir(_tempDir);
    } catch (e) {
    }
    setState(() {
      cache = _cache;
    });
  }

  delTemp() async {
    try {
      final _tempDir = await getTemporaryDirectory();
      // EasyLoading.show(status: '清除中');
      // PermissionStatus status = await Permission.storage.status;
      // print(status);
      // await Utils.delDir(_tempDir);
      // EasyLoading.dismiss();
      // EasyLoading.showSuccess('清除成功');
      Toast.show('清除成功', duration: Toast.lengthLong, gravity: Toast.center);
      getSize();
    } catch (err) {
      // EasyLoading.dismiss();
      // EasyLoading.showError('清除失败');
      Toast.show('清除失败',
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.center);
    }
  }

  @override
  void initState() {
    super.initState();
    getSize();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('系统设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 6.0),
            child: Column(
              children: [
                ListTile(
                  title: Text('编辑资料'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(
                  height: 0,
                ),
                // ListTile(
                //   title: Text('激活电视'),
                //   trailing: Icon(Icons.chevron_right),
                // ),
                // Divider(
                //   height: 0,
                // ),
                ListTile(
                  title: Text('修改密码'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('设备id'),
                  trailing: Text(Utils.ANDROID_UUID),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('使用期限'),
                  trailing: Text('2022年12月01日到期'),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('账号余额'),
                  trailing: Text('¥1111.12'),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('清除缓存'),
                  trailing: Text(Utils.renderSize(cache)),
                  onTap: () {
                    print('清除');
                    delTemp();
                  },
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                    title: Text('推送通知'),
                    trailing: Switch(
                      value: false,
                      onChanged: (bool value) {},
                    )),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('版本更新'),
                  trailing: Text('v 0.0.1'),
                ),
                Divider(
                  height: 0,
                ),
                // ListTile(
                //   title: Text('商务联系'),
                //   trailing: Text('123432@54354fd'),
                // ),
                // Divider(
                //   height: 0,
                // ),
                // ListTile(
                //   title: Text('售后服务微信'),
                //   trailing: Text('fefefgf3434'),
                // ),
                // Divider(
                //   height: 0,
                // ),
                // ListTile(
                //   title: Text('客服电话'),
                //   trailing: Text('123123123'),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 6.0),
            child: Column(
              children: [
                ListTile(
                  title: Text('关于华视酒店管理'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  title: Text('帮助中心&常见问题'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.white,
            child: TextButton(
                onPressed: () {
                  PubMoudle.removeHotelIdAndToken();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(Colors.white)
                // ),
                child: Text(
                  '退出登录',
                  style: TextStyle(color: Colors.blue),
                )),
          )
        ],
      ),
    );
  }
}
