import 'package:flutter/material.dart';

import '/http/pub.dart';

class BtnListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('房间续订'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('微信拓客'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('客房留言'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('商品管理'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('早餐餐券'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('电视AI设置'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('电话设置'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text('机器人送物设置'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
        ListTile(
          onTap: () {},
          title: Text('无人酒店房间飞单预警'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
