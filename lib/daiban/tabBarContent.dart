import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:xftts_fluttify/xftts_fluttify.dart';
import '/V/showDefineAlertWidget.dart';
import '/common/nsLog.dart';
import 'ke_xu_item.dart';
import '/daiban/M/article.dart';
import '/http/pub.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/M/mqttMsgModel.dart';
import '/mqtt/msg.dart';
import '/http/base_response.dart';

class TabBarContent extends StatefulWidget {
  final String myTitle;

  const TabBarContent({Key? key, required this.myTitle}) : super(key: key);

  @override
  State<TabBarContent> createState() => _TabBarContentState();
}

class _TabBarContentState extends State<TabBarContent> {
  List<Article> _list = [];
  ScrollController _controller = ScrollController();
  int page = 0;
  String status = '';
  int type = 0;
  MsgSocket msgSocket = MsgSocket.getInstance();

  _getData([type]) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        '',
        'get',
        '/api/hotel/$hotelId/customer-demand/list',
        {'page': page, 'pageSize': '10', 'status': status});
    if (data == null) {
      print('需要重新登录');
      // PubMoudle().showCupertinoDialog(context!);
      Navigator.pushNamed(context!, '/login', arguments: null);
      return;
    }
    BaseResponse baseResponse = BaseResponse.fromJson(data.data);
    if (baseResponse.code != 200) {
      NSLog(baseResponse.data, StackTrace.current);
      return;
    }
    List jsonList = baseResponse.data['records'];
    List<Article> listData = jsonList.map((e) => Article.fromJson(e)).toList();
    // Article article = Article();
    // listData.insert(0,article);
    // print(data.data['data']['records']);
    // print(listData);
    if (mounted) {
      if (page > 0) {
        setState(() {
          // _list.addAll(listData);
          _list += listData;
        });
      } else {
        setState(() {
          _list = listData;
          // // debug
          // var rng = new Random();
          // var random_number = rng.nextInt(listData.length);
          // //print(random_number);//0-99 random_number
          // for (int i = 1; i <= random_number+1; i++) {
          //   _list.add(listData[random_number]);
          //   print('待办 - $i');
          // }
        });
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.myTitle == '未处理') {
      status = 'pending';
      type = 1;
    } else if (widget.myTitle == '正处理') {
      status = 'process';
      type = 2;
    } else if (widget.myTitle == '已处理') {
      status = 'finish';
      type = 3;
    }
    _getData();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      // print(maxScroll);
      // print(pixels);
      if (maxScroll == pixels) {
        page++;
        _getData();
      }
    });
    if (widget.myTitle == '未处理') {
      msgSocket.client?.updates?.listen((
          List<MqttReceivedMessage<MqttMessage>> c) {
        print('mqtt:,主题: <>');
        final MqttReceivedMessage receivedMessage = c.first;
        final MqttPublishMessage message = receivedMessage.payload;
        final payload = MqttPublishPayload.bytesToStringAsString(
            message.payload.message);
        print('mqtt:$payload,主题: <${c[0].topic}>');
        MqttMsgModel mqttMsgModel = MqttMsgModel.fromJson(payload);
        if (mqttMsgModel.type!.contains("CustomerDemand")) {
          if (mqttMsgModel.data!.status!.contains("pending")) {
            //       //[LCSwiftUtils.new showButtonBarMessage];
            //       _AccM.accountInfoModel.last_send_msg = NSDate.new;
            //   [LCUtils lcLocalPush:1 :@"协作处理!" :@"" :[mqttMsgModel.data.roomNumber addStr:@"号房间 有新客需"]];
            //   [[NSNotificationCenter defaultCenter] postNotificationName:@"LCKeXuTalkMsgNotification" object:idStr];
            String message = mqttMsgModel.data!.roomNumber! + "号房间 有新客需";
            String idStr = mqttMsgModel.data!.id!;
            // Synthesizer _synthesizer;
            // XfTTS.instance.createSynthesizer().then((it) => _synthesizer = it);
            // _synthesizer.startSpeaking(message);
            // XfTTS.instance.createSynthesizer().then((it) {
            //   it.startSpeaking(message);
            // });
            speak(message);

            _refresh();
            // new TestNotification(count: 1);
            // Notification(idStr).dispatch(context);
          }
        }
      });
    }
  }
  Future speak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    /// 设置语言
    await flutterTts.setLanguage("zh-CN");

    /// 设置音量
    await flutterTts.setVolume(0.8);

    /// 设置语速
    await flutterTts.setSpeechRate(0.5);

    /// 音调
    await flutterTts.setPitch(1.0);

    // text = " 你好？";
    if (text != null) {
      if (text.isNotEmpty) {
        await flutterTts.speak(text);
      }
    }
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
              // return index == 0 ? HeaderCell() : NewsItem(_list[index - 1], 1);
              // return NewsItem(_list[index], type);
              return KeXuItem(_list[index], type, onCountSelected);//, _getData()
            },
            controller: _controller,
          ),
        ),
        onRefresh: _refresh);
  }
  onCountSelected(){
    print("Count was selected");
    _refresh();
  }
}

class HeaderCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Row(
        // crossAxisAlignment: CrossAxisAlignment.start,//垂直水平对其
        // children: [
        Text(
          '房号',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          '时间',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          '处理内容',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          '状态',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        SizedBox(
          width: 55.0,
        ),
        SizedBox(
          width: 55.0,
        ),
        // ],
        // )
        Divider(
          height: 20.0,
        ),
      ],
    );
  }
}

class NewsItem extends StatelessWidget {
  final Article article;
  final int type;

  NewsItem(this.article, this.type);

  // const NewsItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(article);
    return Row(
      children: [
        Divider(
          height: 40.0,
        ),
        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.start,//垂直水平对其
            children: [
              Container(
                width: 140,
                child: Text(
                  '${article.roomNumber}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 185,
                child: Text(
                  timeago.format(DateTime.parse(article.createTime.toString()),
                      locale: 'cn'),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 0.0,
              ),
              Container(
                width: 155,
                child: Text(
                  '${article.content}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              // Container(
              //   width: 25,
              //   height: 25,
              //   child: Image.asset(
              //     'images/warning.png',
              //   ),
              // ),
              // SizedBox(
              //   width: 7.0,
              // ),
              // Text(
              //   '${article.status}', //'未处理',
              //   style: TextStyle(
              //       fontWeight: FontWeight.w600, color: Colors.black54),
              // ),
// Text('状态',style: TextStyle(fontWeight: FontWeight.w600,color:Colors.black54),),
            ],
          ),
        ),
// Icon(Icons.warning),

        SizedBox(
          width: 15.0,
        ),
        Text(
          '正在处理',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: type > 1 ? Colors.transparent : Colors.white,
              backgroundColor: type > 1 ? Colors.transparent : Colors.blue),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          '已处理',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: type > 2 ? Colors.transparent : Colors.white,
              backgroundColor: type > 2 ? Colors.transparent : Colors.green),
        ),
      ],
    );
  }
}



//
//
// class TabBarContent1 extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(15.0),
//         child: ListView(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '房号',
//                 style: TextStyle(color: Colors.black, fontSize: 16.0),
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               RichText(
//                   text: TextSpan(
//                       text: '',
//                       style: TextStyle(
//                         color: Colors.black87,
//                       ),
//                       children: [
//                     TextSpan(
//                       text: '时间',
//                       style: TextStyle(
//                         color: Colors.black87,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '处理内容',
//                       style: TextStyle(
//                         color: Colors.black87,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '状态',
//                       style: TextStyle(
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ]))
//             ],
//           ),
//           Divider(height: 30.0,),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '房号'+myTitle,
//                 style: TextStyle(color: Colors.black, fontSize: 16.0),
//               ),
//               // Row(
//               //   children: [
//               //     Expanded(child: Image.network('src'))
//               //   ],
//               // ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               RichText(
//                   text: TextSpan(
//                       text: '',
//                       style: TextStyle(
//                         color: Colors.black87,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: '时间',
//                           style: TextStyle(
//                             color: Colors.black87,
//                           ),
//                         ),
//                         TextSpan(
//                           text: '处理内容',
//                           style: TextStyle(
//                             color: Colors.black87,
//                           ),
//                         ),
//                         TextSpan(
//                           text: '状态',
//                           style: TextStyle(
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ]))
//             ],
//           ),
//         ]));
//   }
// }
