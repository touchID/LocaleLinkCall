import 'package:flutter/material.dart';
import '/daiban/searchBox/searchBox.dart';
import 'tabBarContent.dart';
import 'tabBarBtn.dart';

class Daiban extends StatelessWidget {

  // const Daiban({Key? key}) : super(key: key);
  Daiban({Key? key, required this.title}) : super(key: key);
  final String title;
  bool refreshClick = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // leading:
            //     Row(mainAxisAlignment: MainAxisAlignment.end,children:[ Expanded(child: SizedBox(width: 20,)),Text(title,textAlign: TextAlign.center)]),
            title: SearchBox(),
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBarBtn(),
            ),
            // leading: Placeholder(
            //   fallbackWidth: 100.0,
            //   fallbackHeight: 100.0,
            //   color: Colors.orange,
            // ),
            // actions: [
            //   // Platform.isAndroid ? SizedBox() :
            //   GestureDetector(
            //     onTap: (){
            //       print('刷新');
            //       // loadData();
            //     },
            //     child: SizedBox(
            //       width: 50.0,
            //       height: 50.0,
            //       child: Icon(Icons.refresh),
            //     ),
            //   ),
            // ],
          ),
          body: TabBarView(
            children: [
              TabBarContent(myTitle: "未处理"),
              TabBarContent(myTitle: "正处理"),
              TabBarContent(myTitle: "已处理"),
              // TabBarContent(myTitle: "全部"),
            ],
          ),
        ));
  }
}
