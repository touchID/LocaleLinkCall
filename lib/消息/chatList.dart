import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../http/pub.dart';

class ChatListPage extends StatefulWidget {
  final String? id;
  final String? roomNumber;

  ChatListPage(this.id, this.roomNumber);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("房间${widget.roomNumber}"),
        centerTitle: true,
      ),
      body: ChatSend(widget.id),
    );
  }
}

class ChatSend extends StatefulWidget {
  final String? id;

  const ChatSend(this.id);

  // const ChatSend({Key? key}) : super(key: key);

  @override
  State<ChatSend> createState() => _ChatSendState();
}

class _ChatSendState extends State<ChatSend> {
  List<String> _list = [];

  TextEditingController _textUsernameEditingController =
      new TextEditingController();

  void _sendMsgData(id, sendString) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        '',
        'post',
        '/api/hotel/$hotelId/send-content',
        {"roomId": id, "content": sendString});
    // if (data == null) {
    //   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    //   return;
    // }
    //{"success":true,"data":{"hotelId":62,"hotelAccount":"123456","hotelUserName":"前台3","hotelUserPhone":"","createTime":"2022-08-26 17:08:23","updateTime":"2022-08-26 17:08:23"},"code":200,"msg":"成功","timestamp":1661504960717}
    print(data.data);
    if (data.data['code'] == 200) {
      _list.add(sendString);
    }
    String jsonString = data.data['msg'].toString();
    // List<RoomModel> listData =
    // // print(listData);
    Fluttertoast.showToast(
        msg: "$jsonString",
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: data.data['code'] == 200 ? Colors.black : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    if (mounted) {
      setState(() {});
    }
  }

  _sendMsg(str) {
    print('object');
    String sendString = _textUsernameEditingController.text;
    var list = widget.id!.split(',');
    for (String id in list) {
      _sendMsgData(id, sendString);
    }
    _textUsernameEditingController.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView(
          children:
          //[
            _list.map((e) => Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(e),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(224, 239, 251, 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://smartgateway.hsmedia.fun/public/img/avatar.png'),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.0),
            ),
            ).toList(),
          //],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              onSubmitted: (str) {
                _sendMsg(str);
              },
              controller: _textUsernameEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0),
                  hintText: '请输入消息',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.message,
                    color: Colors.grey,
                  )),
            ),
          )),
          TextButton(
            onPressed: () {
              print('发送客房消息');
              _sendMsg('');
            },
            child: Text(
              '发送',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    ]);
  }
// {
//   return Column(
//     children: [
//       Expanded(
//         child: ListView(
//           children: [
//             Padding(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('您好,房间111 你的外卖到了 '),
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(224, 239, 251, 1),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10.0,
//                   ),
//                   SizedBox(
//                     width: 40.0,
//                     height: 40.0,
//                     child: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           'http://smartgateway.hsmedia.fun/public/img/avatar.png'),
//                     ),
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(20.0),
//             )
//           ],
//         ),
//       ),
//       Container(
//         color: Colors.grey[200],
//         padding: EdgeInsets.all(16.0),
//         child: Container(
//           height: 40.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             color: Colors.white,
//           ),
//           child: TextField(
//             onSubmitted: (str){
//               _sendMsg(str);
//             },
//             decoration: InputDecoration(
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 9.0)
//
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
