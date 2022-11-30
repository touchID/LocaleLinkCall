// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '/config/agora.config.dart' as config;
// import '/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// StringUid Example
class StringUid extends StatefulWidget {
  final String channelId;
  const StringUid({Key? key,required this.channelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StringUid> {
  late final RtcEngine _engine;
  bool isJoined = false,      openMicrophone = true,enableSpeakerphone = true;
  double _recordingVolume = 100,
      _playbackVolume = 100;
  late TextEditingController _controller0, _controller1;

  @override
  void initState() {
    super.initState();
    _controller0 = TextEditingController(text: widget.channelId);
    _controller1 = TextEditingController(text: config.stringUid);
    _initEngine();
  }

  @override
  void dispose() {
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
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        // logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        // logSink.log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        // logSink.log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
    ));

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  void _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    await _engine.joinChannelWithUserAccount(
        token: config.token,
        channelId: _controller0.text,
        // userAccount: _controller1.text);
        userAccount: '0');
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              controller: _controller0,
              decoration: const InputDecoration(hintText: 'Channel ID'),
              enabled:false,
            ),
            // TextField(
            //   controller: _controller1,
            //   decoration: const InputDecoration(hintText: 'String User ID'),
            //   enabled:false,
            // ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _switchMicrophone,
                child: Text('麦克风 ${openMicrophone ? '开' : '关'}'),

              ),
            ],
          ),
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
              ): SizedBox(width: 0,),
              !isJoined ?SizedBox(width: 10,):SizedBox(width: 0,),
              ElevatedButton(
                onPressed: isJoined ? _leaveChannel : _joinChannel,
                child: Text('${isJoined ? '挂断' : '接听'} '),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('录音音量:'),
              Slider(
                // value: 100,
                value: _recordingVolume,
                min: 0,
                max: 100,
                divisions: 5,
                label: '录音音量',
                onChanged: isJoined
                    ? (double value) async {
                  setState(() {
                    _recordingVolume = value;
                  });
                  await _engine
                      .adjustRecordingSignalVolume(value.toInt());
                }
                    : null,
              ),
              const Text('播放音量:'),
              Slider(
                // value: 100,
                value: _playbackVolume,
                min: 0,
                max: 100,
                divisions: 5,
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
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: isJoined ? _switchSpeakerphone : null,
                child:
                Text(enableSpeakerphone ? '扬声器' : '耳机'),
              ),
            ],
          ),
        )
      ],
    );
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
}
