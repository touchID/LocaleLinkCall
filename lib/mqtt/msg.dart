import 'package:flutter/material.dart';

import '../M/mqttMsgModel.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../utils.dart';
import '/http/pub.dart';

class MsgSocket {
  MqttQos qos = MqttQos.atLeastOnce;
  MqttClient? client;
  static MsgSocket? _instance;

  MsgSocket._() {
    clientInit();
  }

  static MsgSocket getInstance() {
    if (_instance == null) {
      _instance = MsgSocket._();
    }
    return _instance!;
  }

  clientInit() async {
    await link();
  }

   link() async{
    try {
      final client = MqttServerClient.withPort(
          'mqtt.hassbrain.com', 'pad-' + Utils.ANDROID_UUID, 1883);
      this.client = client;
      client?.logging(on: true);
      //监听消息
      client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        print('mqtt:,主题: <>');
        final MqttReceivedMessage receivedMessage = c.first;
        final MqttPublishMessage message = receivedMessage.payload;
        final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('mqtt:$payload,主题: <${c[0].topic}>');
        MqttMsgModel mqttMsgModel = MqttMsgModel.fromJson(payload);
        if (mqttMsgModel.type!.contains("CustomerDemand")) {
          if (mqttMsgModel.data!.status!.contains("pending")) {
            //       //[LCSwiftUtils.new showButtonBarMessage];
            //       _AccM.accountInfoModel.last_send_msg = NSDate.new;
            //   [LCUtils lcLocalPush:1 :@"协作处理!" :@"" :[mqttMsgModel.data.roomNumber addStr:@"号房间 有新客需"]];
            //   [[NSNotificationCenter defaultCenter] postNotificationName:@"LCKeXuTalkMsgNotification" object:idStr];
            String message = mqttMsgModel.data!.roomNumber!+"号房间 有新客需";
            String idStr = mqttMsgModel.data!.id!;
            // new TestNotification(count: 1);
            // Notification(idStr).dispatch(context);
          }
        }
      });
      // client?.setProtocolV311();/// 设置协议版本，默认是3.1，根据服务器需要的版本来设置
      client?.onSubscribed = onSubscribed;
      client?.onDisconnected = onDisconnected;

      /// Add the successful connection callback
      client?.onConnected = onConnected;

      /// Set a ping received callback if needed, called whenever a ping response(pong) is received
      /// from the broker.
      client?.pongCallback = pong;

      await client?.connect('vcs-pad', 'vcs-ojlk@#AASDCX21312');
      String HotelId = await PubMoudle.getHotelId(); //正确获取酒店id的写法
      await client?.subscribe(
          "/hassmedia/group/hotel/$HotelId", MqttQos.atLeastOnce);
    } catch (err) {
      print(err);
    }
  }
  _configSSL() async{
    // /// 证书路径
    // var certPath = "assets/xxxx.cer";
    // /// 开启安全设置
    // client?.secure = true;
    // /// 创建SecurityContext
    // final mqttContext = SecurityContext.defaultContext;
    // /// 加载SSL证书
    // var byteData = await rootBundle.load(certPath);
    // /// 将证书的buffer数据添加到context中
    // mqttContext.setClientAuthoritiesBytes(byteData.buffer.asUint8List());
    // /// client指定context.
    // client?.securityContext = mqttContext;
  }
  void onConnected() {
    print('连接成功');
  }

// 连接断开
  void onDisconnected() {
    print('连接断开');
  }

// 订阅主题成功
  void onSubscribed(String topic) {
    print('订阅主题$topic成功');
  }

// 订阅主题失败
  void onSubscribeFail(String topic) {
    print('订阅主题 $topic失败');
  }

// 成功取消订阅
  void onUnsubscribed(String topic) {
    print('成功取消$topic主题订阅');
  }

// 收到 PING 响应
  void pong() {
    print('收到 PING 响应');
  }

  ///发布消息
  publishMessage(String msg) {
    ///int数组
    // Uint8Buffer uint8buffer = Uint8Buffer();
    // ///字符串转成int数组 (dart中没有byte) 类似于java的String.getBytes?
    // var codeUnits = msg.codeUnits;
    // //uint8buffer.add()
    // uint8buffer.addAll(codeUnits);
    // client?.publishMessage(publishTopic, qos, uint8buffer);

    // Uint8Buffer uint8buffer = Uint8Buffer();
    // ///字符串转成int数组 (dart中没有byte) 类似于java的String.getBytes?
    // var codeUnits = msg.codeUnits;
    // //uint8buffer.add()
    // uint8buffer.addAll(codeUnits);
    // client?.publishMessage(publishTopic, qos, uint8buffer);

  }
}
