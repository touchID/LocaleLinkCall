import 'package:flutter/material.dart';

class TabBarBtn extends StatelessWidget {
  const TabBarBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black45,
          labelStyle: TextStyle(
              fontSize: 16.0
          ),
          indicatorColor: Colors.blueAccent,
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.label,
          // labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
          // isScrollable: true,//页面多时 可以滚动
          tabs: [
            Tab(
              text: '待办',
            ),
            Tab(
              text: '正处理',
            ),
            Tab(
              text: '已完成',
            ),
            // Tab(
            //   text: '全部',
            // ),
          ]),
    );
  }
}