import 'package:flutter/material.dart';
import '/http/pub.dart';
import '/门/M/roomModel.dart';
import 'chatList.dart';

class ChatContent extends StatefulWidget {
  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  List<RoomModel> _list = [];
  ScrollController _controller = ScrollController();
  int page = 0;
  String status = '';

  void _getData() async {
    String hotelId = await PubMoudle.getHotelId();
    var parameter = {'page': page, 'pageSize': '9999', 'status': status};
    // print(parameter);
    var data = await PubMoudle().httpRequest(
        '',
        'get',
        '/api/hotel/$hotelId/room/list',
        parameter);
    if (data == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    // print(data.data);
    List jsonList = data.data['data'];
    List<RoomModel> listData =
    jsonList.map((e) => RoomModel.fromJson(e)).toList();
    // // print(data.data['data']);
    // print(listData);
    if (mounted) {
      if (page > 0) {
        setState(() {
          _list.addAll(listData);
        });
      } else {
        setState(() {
          _list = listData;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

    // _controller.addListener(() {
    //   var maxScroll = _controller.position.maxScrollExtent;
    //   var pixels = _controller.position.pixels;
    //   // print(maxScroll);
    //   // print(pixels);
    //   if (maxScroll == pixels) {
    //     page++;
    //     _getData();
    //   }
    // });
  }

  Future _refresh() async {
    page = 0;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return KeXuItem(_list[index]);
            },
            controller: _controller,
          ),
        ),
        onRefresh: _refresh);
  }
}

class KeXuItem extends StatelessWidget {
  final RoomModel roomModel;

  KeXuItem(this.roomModel);

  _getStatusIcon(type) {
    return type;
  }

  pushChatListPageChildren(BuildContext context) {
    // TODO: implement debugDescribeChildren
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListPage(roomModel.id,roomModel.roomNumber)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('点击跳转到发送');
        pushChatListPageChildren(context);
      },
      // selected: true,
      // leading: Container(
      //   // padding: EdgeInsets.fromLTRB(0, 11, 0, 9),
      //   // width: 25,
      //   // height: 25,
      //   child: SizedBox(
      //     width: 50.0,
      //     height: 50.0,
      //     // child: CircleAvatar(
      //     //   child: Text(_getStatusIcon(article.ol)),
      //     // ),
      //   ),
      // ),
      trailing: GestureDetector(
        onTap: () {
          print('点击跳转到发送');
          pushChatListPageChildren(context);
        },
        child: Text('发送', style: TextStyle(color: Colors.blue)),
      ),
      title: Text('房间${roomModel.roomNumber}',
          style: TextStyle(fontSize: 16.0, color: Colors.black)),
      // subtitle: Text('房型 ${article.roomtypeid} ',//\nid: ${article.id}',
      //     style: TextStyle(fontSize: 15.0, color: Colors.black54)),
    );
  }
}