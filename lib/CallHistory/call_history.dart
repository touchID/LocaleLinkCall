import 'dart:convert';

import 'package:flutter/material.dart';

import '../http/base_response.dart';
import '../http/pub.dart';
// import '../model/city_model.dart';
import 'CallLogModel.dart';
import 'Records.dart';
import 'call_history_item.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  List<Records> list = [];
  TextEditingController _searchController = TextEditingController();
  String searchStr = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 1), () {
      loadData();
    });
  }

  void loadData() async {
    String hotelId = await PubMoudle.getHotelId();
    var parameter = {'page': '0', 'pageSize': '9999', 'searchValue': '$searchStr'};
    // print(parameter);
    var data = await PubMoudle().httpRequest('', 'get', '/api/hotel/$hotelId/yunxin/list', parameter);
    if (data == null) {
      return;
    }
    BaseResponse baseModel = BaseResponse.fromJson(data.data);
    if (baseModel.code != 200) {
      // NSLog(baseModel.data, StackTrace.current);
      return;
    }
    print(json.encode(baseModel.data));
    // List jsonList = baseModel.data ?? [];
    CallLogModel callLogModel = CallLogModel.fromJson(baseModel.data);
    // print(json.encode(callLogModel.records!));
    if (!mounted) {
      return;
    }
    if (callLogModel.records!.length == 0) {
      list = [];
      list.clear();
      setState(() {});
      return;
    } else {
      list = callLogModel.records!;
      setState(() {});
    }

    // List<Records> listData =
    // callLogModel.map((e) => RoomModel.fromJson(e)).toList();
    // List<CityModel> roomList = [];
    // for (int i = 0, length = listData.length; i < length; i++) {
    //   RoomModel roomModel = listData[i];
    //   CityModel cityModel = CityModel();
    //   cityModel.name = roomModel.roomNumber;
    //   cityModel.id = roomModel.id.toString();
    //   roomList.add(cityModel);
    // }
    // if (listData.length == 0) {
    //   cityList = [];
    //   cityList.clear();
    //   setState(() {});
    //   return;
    // }
    // cityList.clear();
    // cityList.addAll(roomList);
    // if (!mounted) {return;}
    //
    // // print(data.data['data']);
    // print(listData);
    // if (mounted) {
    //   setState(() {
    //   });
    // }
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
                style: TextStyle(color: searchStr.length > 0 ? Colors.blue : Color(0xFF999999), fontSize: 14),
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
        title: Text('客房来电记录'),
        centerTitle: true,
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
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CallHistoryItem(list[index]);
                  },
                  // controller: _controller,
                ),
              ),
            ),
            // Expanded(child: CallHistoryItem(cityList)),
          ],
        ),
      ),
    );
  }
}
