import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

import '/M/city_model.dart';
import '/V/azlistview.dart';
import '../common/nsLog.dart';
import '../http/base_response.dart';
import '../http/pub.dart';
import '../utils.dart';
import '../门/M/roomModel.dart';

class RoomMsgListPage extends StatefulWidget {
  // final String city;
  // ,required this.city
  const RoomMsgListPage({Key? key}) : super(key: key);

  @override
  _RoomMsgListPageState createState() => _RoomMsgListPageState();
}

class _RoomMsgListPageState extends State<RoomMsgListPage> {
  List<CityModel> cityList = [];
  List<CityModel> seletedArray = [];
  final _searchController = TextEditingController();
  String searchStr = '';
  bool allSelected = false;

  pushLoginVC() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 1), () {
      loadData();
    });
  }

  void setupAllButtonSelected() {
    print("seletedArray.count = ${seletedArray.length}");
    if (seletedArray.length == cityList.length) {
      allSelected = true;
    } else {
      allSelected = false;
    }
  }

  void seletedAllClick() {
    seletedArray = [];
    if (allSelected) {
      for (CityModel cityModel in cityList) {
        seletedArray.add(cityModel);
      }
    }
    setState(() {});
  }

  void loadData() async {
    String hotelId = await PubMoudle.getHotelId();
    var parameter = {'page': '0', 'pageSize': '9999', 'searchValue': '$searchStr'};
    // print(parameter);
    var data = await PubMoudle().httpRequest('', 'get', '/api/hotel/$hotelId/room/list', parameter);
    if (data == null) {
      return;
    }
    BaseResponse baseModel = BaseResponse.fromJson(data.data);
    if (baseModel.code != 200) {
      NSLog(baseModel.data, StackTrace.current);
      return;
    }
    List jsonList = baseModel.data ?? [];
    List<RoomModel> listData = jsonList.map((e) => RoomModel.fromJson(e)).toList();
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
    if (!mounted) {
      return;
    }
    _handleList(cityList);
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
          // InkWell(
          //   onTap: () {
          //     //返回上一界面
          //     // Navigator.pop(context, widget.city);
          //       loadData();
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Text(
          //       searchStr.length > 0 ?
          //       "搜索"
          //           :
          //       "搜索"
          //       ,
          //       style: TextStyle(color: searchStr.length > 0 ? Colors.black:Color(0xFF999999), fontSize: 14),
          //     ),
          //   ),
          // ),
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
                style: TextStyle(color: searchStr.length > 0 ? Colors.blue : Color(0xFF999999), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getListItem(BuildContext context, CityModel model) {
    return Container(
        child: Column(children: [
      ListTile(
        leading: Container(
          padding: EdgeInsets.fromLTRB(0, 11, 0, 9),
          // width: 25,
          // height: 25,
          child: Icon(
            Utils.checkSeleted(seletedArray, model) ? Icons.check_circle : Icons.check_circle_outline,
            color: Colors.blue,
            // Image.asset( 'images/check-circle-filled.png',
          ),
        ),
        title: Text('房间${model.name!}', style: TextStyle(fontSize: 16.0, color: Colors.black)),
        onTap: () {
          if (Utils.checkSeleted(seletedArray, model)) {
            seletedArray.remove(model);
          } else {
            seletedArray.add(model);
          }
          setupAllButtonSelected();
          setState(() {});
          // Navigator.pop(context, model.name);
        },
        trailing: GestureDetector(
          onTap: () {
            Utils.pushVC2(context, model);
          },
          child: Container(
            child: Text('发送     ', style: TextStyle(color: Colors.blue)),
          ),
        ),
      ),
      Divider(
        height: 0,
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('给客房发消息'),
        centerTitle: true,
        leading: SizedBox(
          // width: 60.0,
          // height: 60.0,
          // child: CircleAvatar(
          child: Icon(Icons.access_alarm),
          // ),
        ),
        actions: [
          // Platform.isAndroid ? SizedBox() :
          GestureDetector(
            onTap: () {
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
            Expanded(
              child: Material(
                color: Colors.white, //Color(0x80000000),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(left: 0, top: 0, right: 0),
                  // shape: const RoundedRectangleBorder(
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(0.0),
                  //   topRight: Radius.circular(0.0),
                  // ),
                  // ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15.0),
                        height: 50.0,
                        child: Text("当前房间数量: ${cityList.length}"),
                      ),
                      Expanded(
                        child: AzListView(
                          data: cityList,
                          itemCount: cityList.length,
                          itemBuilder: (BuildContext context, int index) {
                            CityModel model = cityList[index];
                            return getListItem(context, model);
                          },
                          padding: EdgeInsets.zero,
                          susItemBuilder: (BuildContext context, int index) {
                            CityModel model = cityList[index];
                            String tag = model.getSuspensionTag();
                            return Utils.getSusItem(context, tag);
                          },
                          indexBarData: ['★', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '#'], //...kIndexBarData],
                          // indexBarWidth: 35.0,
                          // indexBarHeight: 11,
                          // indexBarItemHeight:22,
                        ),
                      ),
                      Container(
                        // height: 60,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            // SizedBox(width: 0,),
                            GestureDetector(
                              onTap: () {
                                print('全选');
                                allSelected = !allSelected;
                                seletedAllClick();
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 15.0),
                                height: 50.0,
                                child: Icon(
                                  allSelected ? Icons.check_circle : Icons.check_circle_outline,
                                  color: Colors.blue,
                                ), //Text("全选",style: TextStyle(color: Colors.blue)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  print('全选');
                                  allSelected = !allSelected;
                                  seletedAllClick();
                                },
                                child: Text("全选", style: TextStyle(color: Colors.blue))),
                            SizedBox(
                              width: 20,
                            ),
                            Text("已选${seletedArray.length}间", style: TextStyle(color: Colors.grey)),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(left: 15.0),
                                  // height: 50.0,
                                  child: SizedBox(
                                    width: 105,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                                        padding: const EdgeInsets.all(12.0),
                                        backgroundColor: Colors.blue, // 背景色
                                        foregroundColor: Colors.white, // 文字/图标颜色
                                      ),
                                      onPressed: () {
                                        print('发送');
                                        CityModel cityModel = CityModel();
                                        List ids = [];
                                        List names = [];
                                        for (CityModel model in seletedArray) {
                                          ids.add(model.id);
                                          names.add(model.name);
                                        }
                                        cityModel.id = ids.join(','); //list转换成字符串
                                        cityModel.name = names.join(','); //list转换成字符串
                                        Utils.pushVC2(context, cityModel);
                                      },
                                      child: const Text(
                                        '发送',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                  //Text("发送",style: TextStyle(color: Color(0xFF999999)) /*Colors.blue*/,),
                                  ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
