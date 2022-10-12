import 'package:flutter/material.dart';
import 'M/article.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'V/do_sheet.dart';


class KeXuItem extends StatelessWidget {
  final VoidCallback onCountSelected;
  final Article article;
  final int type;
  KeXuItem(this.article, this.type, this.onCountSelected );

  _getIcon(type) {
    if (type.contains('咖啡')) {
      return 'https://www.starbucks.com.cn/images/products/espresso.jpg';
    }else
    if (type.contains('水')) {
      return 'https://www.starbucks.com.cn/images/products/12oz-white-frosted-glass-cup.jpg';
    }else{
      return 'https://www.starbucks.com.cn/images/products/espresso.jpg';
    }
  }


  // const NewsItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // selected: true,
      leading: Container(
        padding: EdgeInsets.fromLTRB(0, 11, 0, 9),
        // width: 25,
        // height: 25,
        child:
        1==1 ?
        CircleAvatar(
          backgroundImage: NetworkImage(_getIcon(this.article.goods)),
        )
            :
        Image.asset( 'images/warning.png',
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 5.0,
          ),
          Text(
            // '2022年8月11日11:50:21'
              timeago.format(DateTime.parse(article.createTime.toString()),
                  locale: 'cn'),
              style: TextStyle(fontSize: 15.0, color: Colors.black54)),
          SizedBox(
            height: 1.0,
          ),
          article.status == 'finish'? Text('已完成', style: TextStyle(color: Colors.grey))
              :
          GestureDetector(
            onTap: () {
              // ///从底部弹出弹框
              // showCupertinoModalPopup(
              //   context: context,
              // builder: (context) {
              //   return CupertinoActionSheet(
              //     ///底部弹出的提示框
              //     title: Text(
              //       'widget.title',
              //       style: TextStyle(fontSize: 22),
              //     ),
              //     actions: [
              //       CupertinoActionSheetAction(
              //           onPressed: () {
              //             //
              //             //   Navigator.pop(context);
              //             //
              //             //   widget.confirmCallback(widget.option1);
              //             //
              //           },
              //           child: Text('正处理')),
              //       CupertinoActionSheetAction(
              //           onPressed: () {
              //             //
              //             //   Navigator.pop(context);
              //             //
              //             //   widget.confirmCallback(widget.option2);
              //             //
              //           },
              //           child: Text('已完成')),//widget.option2')),
              //     ],
              //     cancelButton: CupertinoActionSheetAction(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       child: Text('取消'),
              //     ),
              //   );
              // });

              // AppTool().showBottomAlert(context, null, "请选择性别", '男', '女');

              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return new SimpleDialog(
              //       // title: new Text('选择'),
              //       children: <Widget>[
              //         new SimpleDialogOption(
              //           child: new Text('正处理'),
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //         new SimpleDialogOption(
              //           child: new Text('已完成'),
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // ).then((val) {
              //   print(val);
              // });
              // print('点击处理');
              if (article.status == 'finish') {
                return;
              }
              if (article.status == 'process') {
                showModalBottomSheet(context: context, builder: (BuildContext context){
                  return DoSheet(2, article.id.toString(),onCountSelected);
                });
                return;
              }
              showModalBottomSheet(context: context, builder: (BuildContext context){
                return DoSheet(1, article.id.toString(),onCountSelected);
              });
            },
            child: Text(
                type == 0 ? (article.status == 'process') ? '(正处理)点击处理':'(待办)点击处理' : '点击处理',
                style: TextStyle(color: Colors.blue)),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: const Text('123'),
          //   style: TextButton.styleFrom(
          //     textStyle: const TextStyle(fontSize: 11),
          //   ),
          // ),
        ],
      ),
      title: Text(
          '房间${article.roomNumber}',
          maxLines:1,
          style: TextStyle(fontSize: 16.0, color: Colors.black54)),
      subtitle: Text('${article.content}',
          style: TextStyle(fontSize: 16.0, color: Colors.black)),
    );
  }
}
