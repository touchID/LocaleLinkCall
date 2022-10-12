import 'package:flutter/material.dart';
import '/CallHistory/Records.dart';

class CallHistoryItem extends StatelessWidget {
  Records records;
  CallHistoryItem(this.records);
  // const RoomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // selected: true,
      leading: Container(
        padding: EdgeInsets.fromLTRB(0, 11, 0, 9),
        width: 40,
        height: 40,
        child: Image.asset( 'images/phone-incoming.png',),
        // child: Image.asset( 'images/呼入-失败.png',),
        //
        // child: Text(
        //     '房间',//${article.roomNumber}',
        //     maxLines:1,
        //     style: TextStyle(fontSize: 16.0, color: Colors.black)
        // ),
      ),
      trailing:Text(
          '2022年8月11日11:50:21'
          //   timeago.format(DateTime.parse(article.createTime.toString()),
          //       locale: 'cn'),
            ,style: TextStyle(fontSize: 15.0, color: Colors.black54)),
      // trailing: Center(
      //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   // children: [
      //   //   SizedBox(
      //   //     height: 5.0,
      //   //   ),
      //   child:
      //     Text(
      //       '2022年8月11日11:50:21'
      //       //   timeago.format(DateTime.parse(article.createTime.toString()),
      //       //       locale: 'cn'),
      //         ,style: TextStyle(fontSize: 15.0, color: Colors.black54)),
      //   // ],
      // ),
      title: Text(
          '房间',//${records.roomNumber}',
          maxLines:1,
          style: TextStyle(fontSize: 16.0, color: Colors.black)
      ),

    );
  }

}
