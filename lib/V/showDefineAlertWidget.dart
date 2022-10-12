import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

class ShowDefineAlertWidget extends StatefulWidget {
  final VoidCallback confirmCallback;
  final String title;
  final String hintText;

  const ShowDefineAlertWidget(this.confirmCallback, this.title, this.hintText);

  @override
  _ShowDefineAlertWidgetState createState() => _ShowDefineAlertWidgetState();
}

class _ShowDefineAlertWidgetState extends State<ShowDefineAlertWidget> {
  @override
  Widget build(BuildContext context) {
    /// 设置弹框的宽度为屏幕宽度的86%
    var _dialogWidth = MediaQuery.of(context).size.width * 0.86;

    return SimpleDialog(
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(widget.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w100)),
          ),
          Text(widget.hintText,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w100)),
        ],
      ),
      titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      contentPadding: EdgeInsets.zero,
      children: [
        Divider(
          height: 1,
        ),
        TextButton(
            onPressed: () {
              widget.confirmCallback();
            },
            child: Container(
              width: _dialogWidth,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                '确定',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            )),
      ],
    );
  }
}
