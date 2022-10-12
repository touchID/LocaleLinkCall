import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';import '../M/city_model.dart';


import '../common/nsLog.dart';
import '../http/base_response.dart';
import 'M/roomModel.dart';
// import '../model/city_model.dart';
import './qr/qrCode.dart';
import 'room_item.dart';
import '/V/showDefineAlertWidget.dart';
import '/V/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import '../http/pub.dart';

class RoomListPage extends StatefulWidget {
  int type;
  RoomListPage(this.type);

  // final String city;
  // ,required this.city
  // const RoomListPage({Key? key}) : super(key: key);

  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  List CITY_NAME_LIST = ['8001'];

  List<CityModel> cityList = [];
  List<CityModel> _hotCityList = [];
  TextEditingController _searchController = TextEditingController();
  String searchStr = '';

  @override
  void initState() {
    super.initState();
    CITY_NAME_LIST.forEach((value) {
      _hotCityList.add(CityModel(name: value, tagIndex: '★'));
    });
    // cityList.addAll(_hotCityList);
    SuspensionUtil.setShowSuspensionStatus(cityList);
    Future.delayed(Duration(microseconds: 1), () {
      loadData();
    });
  }

  //   rootBundle.loadString('images/china.json').then((value) {
  //     print(value);
  //     cityList.clear();
  //     Map countyMap = json.decode(value);
  //     List list = countyMap['china'];
  //     list.forEach((v) {
  //       cityList.add(CityModel.fromJson(v));
  //     });
  //     _handleList(cityList);
  //   });
  // }catch(err){
  // }
  pushLoginVC (){
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
  void loadData() async {
    String hotelId = await PubMoudle.getHotelId();
    var parameter = {
      'page': '0',
      'pageSize': '9999',
      'searchValue': '$searchStr'
    };
    // print(parameter);
    var data = await PubMoudle().httpRequest(
        '', 'get', '/api/hotel/$hotelId/room/list', parameter);
    if (data == null) {
      return;
    }
    BaseResponse baseModel = BaseResponse.fromJson(data.data);
    if (baseModel.code != 200) {
      NSLog(baseModel.data, StackTrace.current);
      return;
    }
    List jsonList = baseModel.data ?? [];
    List<RoomModel> listData =
        jsonList.map((e) => RoomModel.fromJson(e)).toList();
    List<CityModel> roomList = [];
    for (int i = 0, length = listData.length; i < length; i++) {
      RoomModel roomModel = listData[i];
      CityModel cityModel = CityModel();
      cityModel.name = roomModel.roomNumber;
      cityModel.id = roomModel.id.toString();
      roomList.add(cityModel);
    }
    if (listData.length == 0) {
      cityList = [];
      cityList.clear();
      setState(() {});
      return;
    }
    cityList.clear();
    cityList.addAll(roomList);
    if (!mounted) {return;}
    _handleList(cityList);

    // // print(data.data['data']);
    // print(listData);
    // if (mounted) {
    // setState(() {
    // });
    // }
  }

  void _handleList(List<CityModel> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      // print('pinyin $pinyin');
      list[i].namePinyin = pinyin;
      if (RegExp("[0-9]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
      // print('tagIndex ${list[i].tagIndex}');
    }

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    // add hotCityList.
    cityList.insertAll(0, _hotCityList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(cityList);

    setState(() {});
  }

  Widget header() {
    return Container(
      color: Colors.white,
      height: 44.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                hintText: '请输入房间号',
                // prefixIcon: Icon(Icons.search,color: Colors.grey,),//搜索图标
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCCCCCC),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchStr = value;
                });
                loadData();
              },
            ),
          ),
          Container(
            width: 0.33,
            height: 14.0,
            color: Color(0xFFEFEFEF),
          ),
          InkWell(
            onTap: () {
              _searchController.text = '';
              setState(() {
                searchStr = '';
              });
              loadData();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                searchStr.length > 0 ? "取消" : "取消",
                style: TextStyle(
                    color:
                        searchStr.length > 0 ? Colors.blue : Color(0xFF999999),
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 1 ? '手机门锁&门卡' : '给客房发消息'),
        centerTitle: true,
        actions: [
          // Platform.isAndroid ? SizedBox() :
          GestureDetector(
            onTap: (){
              print('刷新');
              loadData();
            },
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(child: RoomItem(cityList, widget.type)),
          ],
        ),
      ),
    );
  }
}
