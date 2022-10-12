import 'dart:developer';

import 'package:flutter/foundation.dart';

void NSLog(var message, StackTrace trace) {
  if (kDebugMode) {
    //
    FCustomTrace programInfo = FCustomTrace(trace);
    message = message ?? '';
    if (programInfo != null &&
        programInfo.fileName != null &&
        programInfo.lineNumber != null) {
      // print("所在文件: ${programInfo.fileName}, 所在行: ${programInfo.lineNumber}, 打印信息: ${message}");
      log("所在文件: ${programInfo.fileName}, 所在行: ${programInfo.lineNumber}, 打印信息: ${message}");
    } else {
      print("打印内容:${message}");
    }
  } else if (kReleaseMode) {
    print("----ReleaseMode-------");
  } else if (kProfileMode) {
    print("----ProfileMode-------");
  }
}

class FCustomTrace {
  final StackTrace _trace;

  late String fileName;
  late int lineNumber;
  late int columnNumber;

  FCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceString = this._trace.toString().split("\n")[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    //print('-----listOfInfos--===== $listOfInfos  -------=====');
    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    this.columnNumber = int.parse(columnStr);
  }
}
