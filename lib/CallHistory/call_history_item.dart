import 'package:flutter/material.dart';
import '/CallHistory/Records.dart';
import 'package:timeago/timeago.dart' as timeago;

class CallHistoryItem extends StatelessWidget {
  Records records;
  CallHistoryItem(this.records);
  // const RoomItem({Key? key}) : super(key: key);

//判定是否为数字
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // selected: true,
      leading: Container(
        padding: EdgeInsets.fromLTRB(0, 11, 0, 9),
        width: 38,
        height: 38,
        child: Image.asset(
            isNumeric(records.callingName!) ?
            (records.status == '0' ? 'images/呼入-失败.png' : 'images/phone-incoming.png'):
            (records.status == '0' ? 'images/呼出-失败.png' : 'images/phone-outgoing.png'),
        ),
      ),
      trailing:Text(
          // '2022年8月11日11:50:21'
            timeago.format(DateTime.parse(records.createTime.toString()),
                locale: 'cn')
            ,style: TextStyle(fontSize: 15.0, color: Colors.black54)),
      title: Text(
          isNumeric(records.callingName!) ?
          '房间${records.callingName}' :
          '前台 呼叫 房间${records.calledName}'
          ,
          maxLines:1,
          style: TextStyle(fontSize: 16.0, color: Colors.black)
      ),

    );
  }

}
