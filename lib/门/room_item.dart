import 'package:flutter/material.dart';
import '/utils.dart';
// import 'package:untitled06/门/room_list_page.dart';
import '/V/azlistview.dart';
import '/M/city_model.dart';

class RoomItem extends StatelessWidget {
  List<CityModel> cityList;
  int type;
  RoomItem(this.cityList,this.type);

  // const RoomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //设置阴影的
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
              child: Text("当前房间数量: ${cityList.length-(cityList.length> 0 ? 1 : 0)}"),
            ),
            Expanded(
              child: AzListView(
                data: cityList,
                itemCount: cityList.length,
                itemBuilder: (BuildContext context, int index) {
                  CityModel model = cityList[index];
                  return Utils.getListItem(context, model , type);
                },
                padding: EdgeInsets.zero,
                susItemBuilder: (BuildContext context, int index) {
                  CityModel model = cityList[index];
                  String tag = model.getSuspensionTag();
                  return Utils.getSusItem(context, tag);
                },
                indexBarData: [
                  '★',
                  '0',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '#'
                ], //...kIndexBarData],
                // indexBarWidth: 35.0,
                // indexBarHeight: 11,
                // indexBarItemHeight:22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
