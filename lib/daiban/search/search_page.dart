import 'package:flutter/material.dart';

import '/http/pub.dart';
import '../ke_xu_item.dart';
import '/daiban/M/article.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Article> _list = [];
  String searchStr = '';
  TextEditingController _textEditingController = new TextEditingController();

  // ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    //_getData();
  }

  _getData([type]) async {
    String hotelId = await PubMoudle.getHotelId();
    var data = await PubMoudle().httpRequest(
        '',
        'get',
        '/api/hotel/$hotelId/customer-demand/list',
        {'page': '0', 'pageSize': '9999', 'status': ''});
    if (data == null) {
      return;
    }
    //searchStr
    List jsonList = data.data['data']['records'];
    List<Article> listData = jsonList.map((e) => Article.fromJson(e)).toList();
    // print(data.data['data']['records']);
    // print(listData);
    if (mounted) {
      setState(() {
        _list = listData;
      });
    }
  }

  Widget commendContent() {
    return
        // Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '搜索结果',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black45,
            ),
          ),
          Text('匹配的数据有${_list.length}条')
        ],
      ),
      // )
      // Expanded(
      // child: Container()
      //     Padding(
      //       padding: EdgeInsets.all(5.0),
      //       child: ListView(//.builder(
      // itemCount: _list.length,
      // itemBuilder: (context, index) {
      //   return KeXuItem(_list[index], 0);
      // },
      // controller: _controller,
      // ),
      // ),
      // ),
      // Column(
      //   children: [
      //     ListTile(
      //       title: Text(
      //           '咖啡',
      //         style: TextStyle(
      //           fontSize: 14.0
      //         ),
      //       ),
      //     ),
      //     ListTile(
      //       title: Text(
      //         '咖啡',
      //         style: TextStyle(
      //             fontSize: 14.0
      //         ),
      //       ),
      //     ),
      //   ],
      // )
      //   ],
    );
  }

  Widget searchContent() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return KeXuItem(_list[index], 0,onCountSelected);
          },
          // controller: _controller,
        ),
      ),
    );
  }

  onCountSelected(){
    print("Count was selected.");
  }

  Widget searchHitory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索历史',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black45,
                ),
              ),
              Icon(
                Icons.delete,
                color: Colors.black45,
                size: 20.0,
              )
            ],
          ),
        ),
        Wrap(
          children: [
            Container(
              // color: Colors.red,
              // height: 50.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: (Colors.grey[200])!),
                  top: BorderSide(color: (Colors.grey[200])!),
                ),
              ),
              width: MediaQuery.of(context).size.width / 2,
              child: Text('奶茶'),
            ),
            Container(
              // height: 50.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: (Colors.grey[200])!),
                  top: BorderSide(color: (Colors.grey[200])!),
                ),
              ),
              width: MediaQuery.of(context).size.width / 2,
              child: Text('水'),
            ),
            Divider(
              height: 0,
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _textEditingController,
                onSubmitted: (value) {
                  print(value);
                  searchStr = value;
                  _getData();
                },
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(6.0),
                    hintText: '请输入关键词',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ) //搜索图标
                    ),
              ),
            )),
            TextButton(
              onPressed: () {
                _textEditingController.text = '';
                searchStr = '';
                _getData();
              },
              child: Text(
                '取消',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          searchHitory(),
          commendContent(),
          searchContent(),
        ],
      ),
    );
  }
}
