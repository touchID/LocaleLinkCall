
import 'package:flutter/material.dart';

import 'chatContent.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('给客房发消息'),
          centerTitle: true,
          actions: [
            SizedBox(
              width: 50.0,
              height: 50.0,
              child: Icon(Icons.search),
            ),
          ],
        ),
        // appBar: ,
        body:  ChatContent()
    );
  }
}
