import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:untitled14/CallHistory/call_history_item.dart';
import 'CallHistory/call_history.dart';
import 'CallHistory/call_sink.dart';
import 'CallHistory/join_channel_audio.dart';
import 'CallHistory/log_sink.dart';
import 'daiban/search/search_page.dart';
import 'daiban/tabBarContent.dart';
import '我的/system_settings/sysset.dart';
import '我的/user.dart';
import '门/room_list_page.dart';
import 'daiban/daiban.dart';
import 'roomMessage/room_msg_list_page.dart';
import 'utils.dart';
import 'login/login.dart';
import 'package:badges/badges.dart';

void main() {
  // if (Platform.isAndroid) {
  //   // 屏
  //   WidgetsFlutterBinding.ensureInitialized();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.landscapeRight
  //   ]);
  // }
  timeago.setLocaleMessages('cn', timeago.ZhCnMessages());
  runApp(MyApp());//const
  // XfTTS.instance.init('5e82d068');
  // initPlatformState();
  Utils.init();
  // runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // final botToastBuilder = BotToastInit();
  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: '华视酒店管理',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '华视酒店管理'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => MyHomePage(title: '华视酒店管理'),
        '/login': (context) => Login(),//LoginPage(),
        '/search': (context) => SearchPage(),
        '/sysset': (context) => SysSet(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  var eventBusFn;
  int daibanNum = 0;

  List _bodys = [
    Daiban(title: '华视美达'),
    RoomListPage(1),
    // // RoomListPage(2),
    RoomMsgListPage(),
    // DoorHome(),
    CallHistory(),
    User(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 注册监听器，订阅 eventbus
    eventBusFn = eventBus.on<EventFn>().listen((event){
      // print(event.mqttMsgModel);
      _pushCallVC();
      setState(() {
        daibanNum++;
      });
    });
    // eventBusFn = eventBus.on().listen((data) {
    //   print(data.obj);
    //   _pushCallVC();
    // });
  }
  @override
  void dispose() {
    super.dispose();
    //取消订阅
    eventBusFn.cancel();
  }

  void _pushCallVC() {
    String channelId = '10000';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(
                    '房间:${channelId}' as String),
                // ignore: prefer_const_literals_to_create_immutables
                actions: [const LogActionWidget()],
              ),
              body: JoinChannelAudio (channelId: channelId,) as Widget?,
            )));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: _bodys[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon:Badge(
              badgeContent: Text('${daibanNum}'
                ,style: TextStyle(color: Colors.white),),
              badgeColor: Colors.blue,
              position: BadgePosition.topEnd(),
              child: Icon(Icons.home),
            ),
            label: '待办事项',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: '手机门卡',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: '客房消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_callback_sharp),
            label: '客房来电',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '我的',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          print(index);
          setState((){
            _index = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushCallVC,
        tooltip: '接听',
        child:
    // Row(
    // mainAxisSize: MainAxisSize.min,
    // children: [
    //   CallActionWidget(),
    //   ]),
        const Icon(Icons.phone),
        // shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(15),
        // side: BorderSide(
        //   width: 2,
        //   color: Colors.red,
        // ),
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
