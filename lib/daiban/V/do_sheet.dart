import 'package:flutter/material.dart';
import '../../http/pub.dart';

class DoSheet extends StatelessWidget {
  final int type;
  final VoidCallback onCountSelected;
  final String myId;
  const DoSheet( this.type, this.myId, this.onCountSelected);

  void _processData(BuildContext context) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        '',
        'put',
        '/api/hotel/$hotelId/customer-demand/process/$myId');
    print(data);
    if (data == null) {
      // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    var res = data.data['success'];
    print(data.data['success']);

    // this.refresh();
    // print(listData);
    // Scaffold.of(context).showSnackBar(
    //     SnackBar(content: Text('成功'),)
    // );
  }

  void _finishData(BuildContext context) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        '',
        'put',
        '/api/hotel/$hotelId/customer-demand/finish/$myId');
    if (data == null) {
      //Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    var res = data.data['success'];
    print(data.data['success']);
    // print(listData);
    // Scaffold.of(context).showSnackBar(
    //     SnackBar(content: Text('成功'),)
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: type == 2 ? 136 : 210,
      // color: Colors.red
      child: Column(
        children: [
          type == 2 ? SizedBox() :
          ListTile(
            title: Text('正在处理'
              ,textAlign: TextAlign.center,),
            onTap: () {
              _processData(context);
              onCountSelected();
              Navigator.pop(context);
            },
          ),
          type == 2 ? SizedBox() :
          Divider(),
          ListTile(
            title: Text('已处理',textAlign: TextAlign.center,),
            onTap: () {
              _finishData(context);
              onCountSelected();
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            title: Text('取消',textAlign: TextAlign.center,),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Text(
          //     '正在处理',
          //     style: TextStyle(fontSize: 16),
          //   ),
          // ),
          // Divider(),
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Text(
          //     '已处理',
          //     style: TextStyle(fontSize: 16),
          //   ),
          // ),
          // Divider(),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.all(10.0),
          //     child: Text(
          //       '取消',
          //       style: TextStyle(fontSize: 16),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
