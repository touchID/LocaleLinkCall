import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../http/pub.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/services.dart';

import '../utils.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        centerTitle: true, // 标题居中
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: FormLogin(),
      ),
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  String _huoQuStr = '获取设备权限';
  int _seconds = 0;
  late Timer _timer;
  String username = '';
  String password = '';
  SharedPreferences? sharedPreferences;
  TextEditingController _textUsernameEditingController = new TextEditingController();
  TextEditingController _textPasswordEditingController = new TextEditingController();
  bool passwordVisible = false;

  _getPermissions() async{
    if(_seconds == 0 && username != '') {
      print('开始定时器');
      _startTime();
      driverRegistration();
    }else{
      if(username == '') {
        Toast.show(
            '请输入账号', duration: Toast.lengthShort, gravity: Toast.center);
      }
    }
  }

  void driverRegistration() async {
    try {
      PubMoudle().httpRequest('json','post', 'http://192.168.12.139:1337/api/pads' , { 'data':{'uuid': Utils.ANDROID_UUID} }).then((value){
        print(value);
        // Scaffold.of(context).showSnackBar(
        //     SnackBar(content: Text('${value.data['data']}'),)
        // );
        if(value == null) {
          return;
        }
        Toast.show('${value.data['data']}', duration: Toast.lengthShort, gravity:  Toast.center);
        var code = value.data['code'].toString();
        if(code == '1'){
          // Scaffold.of(context).showSnackBar(
          //     SnackBar(content: Text('设备uuid已发送,请通知管理员进行审核通过'),)
          // );
          Toast.show('设备uuid已发送,请通知管理员进行审核通过', duration: Toast.lengthLong, gravity:  Toast.center);
        }else{
          var message = value.data['message'].toString();
          // Scaffold.of(context).showSnackBar(
          //     SnackBar(content: Text(message),)
          // );
          Toast.show(message, duration: Toast.lengthLong, gravity:  Toast.center);
        }
      });

      // var response = await Dio().get('http://itoto.imblog.in/sql3/index.php');
      // print(response);
      // print(response.statusCode);
      // Dio dio = new Dio();
      // var httpClient = new HttpClient();
      // var uri = new Uri.http('http://itoto.imblog.in', '/sql3', {'name': 'test'});
      // var request = await httpClient.getUrl(uri);
      // var response = await request.close();
    } catch (e) {
      // Scaffold.of(context).showSnackBar(
      //     SnackBar(content: Text('$e'),)
      // );
      Toast.show('$e', duration: Toast.lengthLong, gravity:  Toast.center);
      print(e);
    }
  }

  _startTime(){
    _seconds = 6;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(_seconds == 0){
        _cancelTime();
        return;
      }
      _seconds--;
      setState((){
        if(_seconds == 0) {
          _huoQuStr = '重新获取权限';
        }else{
          _huoQuStr = '$_seconds(S)';
        }
      });
    });
  }

  _cancelTime() {
    _timer.cancel();
  }
// 设置持久化数据
  void _setData(String key , String context) async {
    // 实例化
    sharedPreferences = await SharedPreferences.getInstance();
    // 设置string类型
    await sharedPreferences?.setString(key, context);
    //setState(() {});
  }
  _login() {
    print('点击了登录');
    // 例如下面的例子，两边都带有空格，我想去除 username 两边的空格
    //print(str.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
    PubMoudle().httpRequest('json','post', '/api/hotel/login' , {"username": username.trim(), "password" :password.trim(), 'deviceUuid': Utils.ANDROID_UUID}).then((value){
      print(value);
      if (value == null) {
        return;
      }
      var code = value.data['code'].toString();
      if(code == '200') {
        String token_data = value.data['data'].toString();
        try{
          _setData("token",token_data);
        }catch (err){
        }
        if(token_data.length > 0){
          PubMoudle().httpRequest('','get', '/api/hotel/user/info' , {'Authorization': token_data}).then((value) {
            print(value);
            String hotelId = value.data['data']['hotelId'].toString();
            _setData("hotelId",hotelId);
            // Scaffold.of(context).showSnackBar(
            //     SnackBar(content: Text('登录成功'),)
            // );
            Toast.show('登录成功', duration: Toast.lengthLong, gravity:  Toast.center);
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          });
        }
      }else{
          var message = value.data['msg'].toString();
          Toast.show(message, duration: Toast.lengthLong, gravity:  Toast.center);
        // Scaffold.of(context).showSnackBar(
          //     SnackBar(content: Text(message),)
          // );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //debug info
    //   username = 'huashimeida3';
    //   password = '123456';
    _textUsernameEditingController.text = username;
    _textPasswordEditingController.text = password;
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
    // ]);
    passwordVisible = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose 页面销毁的时候
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Column(
      children: [
        Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: TextField(
              controller: _textUsernameEditingController,
              //keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person, //手机图标
                    color: Colors.grey, //灰色
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  hintText: '请输入账号',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 14.0)),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              // onSubmitted: (value){},
            )),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: TextField(
                        controller: _textPasswordEditingController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock, //锁图标
                              color: Colors.grey, //灰色
                            ),
                            // focusedBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide.none),
                            // enabledBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide.none),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                print('显示');
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                // Icons.remove_red_eye,
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off
                              ),
                            ),
                            suffixText: passwordVisible? "显示":"不显示",
                            hintText: '请输入密码',
                            hintStyle: TextStyle(
                                color: Colors.black38, fontSize: 14.0)),
                        obscureText: !passwordVisible,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        // onSubmitted: (value){},
                      ))),
              // GestureDetector(
              //   onTap: () {
              //     print('获取设备uuid权限');
              //     setState(() {
              //       //_huoQuStr = '60秒倒计时';
              //       _getPermissions();
              //     });
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     width: 110.0,
              //     height: 30.0,
              //     decoration: BoxDecoration(
              //         color: Color.fromRGBO(237, 237, 237, 1),
              //         borderRadius: BorderRadius.circular(120.0)),
              //     child: Text(_huoQuStr), //
              //   ),
              // ),
              // SizedBox(
              //   width: 10.0,
              // )
            ],
          ),
        ),
        Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false, //禁用
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        // prefixIcon: Icon(
                        //   Icons.plumbing, //手机图标
                        //   color: Colors.grey, //灰色
                        // ),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        labelText: Utils.ANDROID_UUID ?? '',
                        // hintText: '设备id',
                        hintStyle: TextStyle(color: Colors.black38, fontSize: 14.0)),
                    onChanged: (value) {
                    },
                    onTap: () {
                      print('复制设备uuid权限');
                      Clipboard.setData(ClipboardData(text:Utils.ANDROID_UUID ?? ''));
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('获取设备uuid权限');
                    setState(() {
                      //_huoQuStr = '60秒倒计时';
                      _getPermissions();
                      Clipboard.setData(ClipboardData(text:Utils.ANDROID_UUID ?? ''));
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 110.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(120.0)),
                    child: Text(_huoQuStr), //
                  ),
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
        ),
        // Expanded(
        //     child: Container(),
        // ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 45.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: double.infinity,
          margin: EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: username == '' || password == ''
                ? null
                : () {
                    print('点击了登录');
                    _login();
                  },
            child: Text(
              '登录',
              style: TextStyle(color: Colors.white),
            ),
            // style: ElevatedButton.styleFrom(
            //   onSurface: Colors.blue, //虽然兼容OutlinedButton 但是 颜色稍浅
            // ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              // overlayColor: MaterialStateProperty.all(Colors.white),//点击之后的颜色
              //更改ElevatedButton和OutlinedButton的禁用颜色
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.blue[100]!; // Disabled color
                }
                return Colors.blue; // Regular color
              }),
            ),
            // elevation: 0.0,
            // color: Colors.blue,
            // disabledColor: Colors.blue[100],
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
