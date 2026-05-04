import 'package:flutter/material.dart';

import '/我的/数据统计/dataCenter/dataCenter.dart';

class UserBtn extends StatelessWidget {
  const UserBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(children: [
        PubBtn(Icons.access_time, '消息记录'),
        PubBtn(Icons.star_border, '发票管理'),
        PubBtn(Icons.data_exploration_outlined, '数据中心'),
        PubBtn(Icons.loyalty, '通讯录'),
      ]),
    );
  }
}

class PubBtn extends StatelessWidget {
  final IconData icon;
  final String str;
  const PubBtn(this.icon, this.str);

  pushDataCenterChildren(BuildContext context) {
    String url = 'https://aisuda.bce.baidu.com/amis/examples/chart';
    if (str == '数据中心') {
      url = 'https://cloud.jimureport.com/bigscreen/#/view/1211961482594553857';
      // url = 'http://192.168.0.21:9898/?t=123';
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => DataCenter(url)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        // Navigator.push(context, route);
        pushDataCenterChildren(context);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 30.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            str,
            style: TextStyle(fontSize: 16.0),
          )
        ],
      ),
    ));
  }
}
