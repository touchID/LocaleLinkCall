import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../http/pub.dart';
import '/config/agora.config.dart' as config;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_watcher/volume_watcher.dart';
import '/CallHistory/log_sink.dart';
import 'package:audioplayers/audioplayers.dart';

/// JoinChannelAudio Example
class JoinChannelAudio extends StatefulWidget {
  /// Construct the [JoinChannelAudio]
  final String channelId;
  const JoinChannelAudio({Key? key,required this.channelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  late final RtcEngine _engine;
  // String channelId = widget.channelId;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100,
      _playbackVolume = 100,
      _inEarMonitoringVolume = 100;
  // late TextEditingController _controller;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileCommunication;
  ///信道
  int _volumeListenerId = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // String channelId = widget.channelId;
    // _controller = TextEditingController(text: channelId);
    _initEngine();
    listeningNativeVolume();
    play();
  }
  /// 播放
  play() async {
    await audioPlayer.setSourceUrl("http://itoto.imblog.in/im_call.caf");//01.mp3");
    // await audioPlayer.setSourceDeviceFile("im_call.caf");//
    // await audioPlayer.setSourceAsset("images/im_call.caf");//
    await audioPlayer.resume();
    print('play resume');
  }
  @override
  void dispose() {
    VolumeWatcher.removeListener(_volumeListenerId);
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: config.appId,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
    ));

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await _engine.setAudioProfile(//设置音频场景
    //   profile: AudioProfileType.audioProfileDefault,
    //   scenario: AudioScenarioType.audioScenarioGameStreaming,
    // );
  }
  ///监测系统音量
  listeningNativeVolume() {
    _volumeListenerId = VolumeWatcher.addListener((volume){
      setState(() {
        _playbackVolume = volume*100;
      });
      if(isJoined){
        _engine.adjustPlaybackSignalVolume(volume.toInt()*100);
      }
    })!;
  }

  // - (void)addData:(NSInteger)status :(NSString *)calledName :(NSString *)callingName {
  // if (self.historyOK) {
  // return;
  // }
  // NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  // [parameters setObject:[@"" addStr:calledName] forKey:@"calledName"];//被叫
  // [parameters setObject:[@"" addStr:callingName] forKey:@"callingName"];//主叫
  // [parameters setObject:[@"" addInteger:status] forKey:@"status"];
  // NSString *post_url = [NSString stringWithFormat:@"%@/api/hotel/%@/yunxin/add",[YYHttpTool get_BASE_POST_URL],_AccM.accountInfoModel.hotelId];
  // @weakify(self)
  // [kNetworkJsonTool POSTWithUrlString:post_url parameters:parameters headers:nil success:^(NSDictionary * _Nonnull dict) {
  // @strongify(self)
  // YZSNetResponse *response01 = [YZSNetResponse yy_modelWithJSON:dict];
  // NSLog(@"dict = %@ ",dict);
  // if (response01.code == 200) {
  // self.historyOK = true;
  // [[NSNotificationCenter defaultCenter] postNotificationName:@"LCRefreshCallListNotification" object:nil];
  // }else {
  // }
  // } failure:^(NSError * _Nonnull error) {
  // NSLog(@"error = %@ ",error);
  // }];
  //
  // }
  void _sendCallOKData(user_id, sendString, status) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        'json',
        'post',
        '/api/hotel/$hotelId/yunxin/add',
        {"calledName": user_id, "callingName": "10000","status":status});//被叫 主叫
    if (data == null) {
      return;
    }
    if (data.data['code'] == 200) {
    }
    if (mounted) {
      setState(() {});
    }
  }
  _joinChannel() async {
    await audioPlayer.stop();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    String channelId = widget.channelId;
    await _engine.joinChannel(
        token: config.token,
        channelId: channelId,//_controller.text,
        uid: config.uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
    _sendCallOKData("1","10000","1");
  }

  _leaveChannel() async {
    await audioPlayer.stop();
    await _engine.leaveChannel();
    if(isJoined == false){
      // _sendCallOKData("1","10000","0");
    }
    setState(() {
      isJoined = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
    });
  }

  _switchMicrophone() async {
    // await await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  _switchSpeakerphone() async {
    await _engine.setEnableSpeakerphone(!enableSpeakerphone);
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
  }

  _switchEffect() async {
    // if (playEffect) {
    //   await _engine.stopEffect(1);
    //   setState(() {
    //     playEffect = false;
    //   });
    // } else {
    //   final path =
    //       (await _engine.getAssetAbsolutePath("assets/im_call.caf"))!;
    //   await _engine.playEffect(
    //       soundId: 1,
    //       filePath: path,
    //       loopCount: 0,
    //       pitch: 1,
    //       pan: 1,
    //       gain: 100,
    //       publish: true);
    //   // .then((value) {
    //   setState(() {
    //     playEffect = true;
    //   });
    // }
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    try {
      await _engine.enableInEarMonitoring(
          enabled: value,
          includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      _enableInEarMonitoring = value;
      setState(() {});
    } catch (e) {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // TextField(
            //   controller: _controller,
              // decoration: const InputDecoration(hintText: '频道 ID'),
            // ),
            // Column(
            //   children: [
            Padding(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            ElevatedButton(
            onPressed: _switchMicrophone,
            child: Text('静音 ${openMicrophone ? '开' : '关'}'),
            ),
            ElevatedButton(
            onPressed: isJoined ? _switchSpeakerphone : null,
            child:
            Text(enableSpeakerphone ? '扬声器' : '听筒'),
            ),
            if (!kIsWeb)
            ElevatedButton(
            onPressed: isJoined ? _switchEffect : null,
            child: Text('暂无${playEffect ? '停止' : '播放'} 铃声'),
    ),
    // Row(
    // mainAxisAlignment: MainAxisAlignment.end,
    // children: [
    // const Text('录音音量:'),
    // Slider(
    // value: _recordingVolume,
    // min: 0,
    // max: 100,
    // divisions: 4,
    // label: '录音音量',
    // onChanged: isJoined
    // ? (double value) async {
    // setState(() {
    // _recordingVolume = value;
    // });
    // await _engine
    //     .adjustRecordingSignalVolume(value.toInt());
    // }
    //     : null,
    // )
    // ],
    // ),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    const Text('播放音量:'),
    Slider(
    value: _playbackVolume,
    min: 0,
    max: 100,
    divisions: 100,
    label: '播放音量',
    onChanged: isJoined
    ? (double value) async {
    setState(() {
    _playbackVolume = value;
    });
    await _engine
        .adjustPlaybackSignalVolume(value.toInt());
    }
        : null,
    )
    ],
    ),
              //耳返 指的是麦克风录制在自己耳机里的声音
    ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    )
              //],
            //),//,
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              !isJoined ?
              ElevatedButton(
                onPressed: _leaveChannel,
                child: Text('${'挂断' } '),
                style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Color(0xffffffff)),                //背景颜色
                    foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
                    // overlayColor: MaterialStateProperty.all(Color(0xffffffff)),                   // 高亮色
                    // shadowColor: MaterialStateProperty.all( Color(0xffffffff)),                  //阴影颜色
                    // elevation: MaterialStateProperty.all(0),                                     //阴影值
                    // textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),                //字体
                    // side: MaterialStateProperty.all(BorderSide(width: 1,color: Color(0xffCAD0DB))),//边框
                    shape: MaterialStateProperty.all(
                        CircleBorder(
                            side: BorderSide(
                              //设置 界面效果
                              color: Colors.green,
                              // width: 280.0,
                              style: BorderStyle.none,
                            )
                        )
                    ),//圆角弧度
                ),
              ): SizedBox(width: 0,),
              !isJoined ?SizedBox(width: 10,):SizedBox(width: 0,),
              ElevatedButton(
                onPressed: isJoined ? _leaveChannel : _joinChannel,
                child: Text('${isJoined ? '挂断' : '接听'} '),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),                //字体颜色
                  shape: MaterialStateProperty.all(
                      CircleBorder(
                          side: BorderSide(
                            //设置 界面效果
                            color: Colors.green,
                            width: 180.0,
                            style: BorderStyle.none,
                          )
                      )
                  ),//圆角弧度
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
