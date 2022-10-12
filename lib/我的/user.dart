import 'package:flutter/material.dart';
import './user_bin.dart';
import './user_info.dart';
import 'btn_list/btn_list_view.dart';

class User extends StatelessWidget {
  const User({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          UserInfo(),
          UserBtn(),
          BtnListPage(),
        ],
      ),
    );
  }
}
