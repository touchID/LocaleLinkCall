import 'package:flutter/material.dart';
import '../M/HotelInfo.dart';
import '/http/base_response.dart';

import '/http/pub.dart';
// import '/M/hotel_info.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String hotelUserName = '';
  String hotelAccount = '';

  getInfoData() {
    PubMoudle.checkUserToken().then((token){
      if(token.length > 0){
        // print(token);
        PubMoudle().httpRequest('','get', '/api/hotel/user/info' , {'Authorization': token}).then((value) {
          // print(value);
          if (value == null) { return; }
          if(value.data == null) { return; }
          BaseResponse baseModel = BaseResponse.fromJson(value.data);
          if (baseModel.code == 200) {
            HotelInfo hotelInfo_model = HotelInfo.fromJson(baseModel.data);
            // print(hotelInfo_model);
            setState(() {
              if (hotelInfo_model.hotelUserName != null) {
                hotelUserName = hotelInfo_model.hotelUserName!;
              }
              if (hotelInfo_model.hotelAccount != null) {
                hotelAccount = hotelInfo_model.hotelAccount!;
              }
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.only(top: 80.0,bottom: 20.0,left: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('http://smartgateway.hsmedia.fun/public/img/avatar.png'),
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(this.hotelUserName
                        ,style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical:3.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)

                          ),
                          child: Text(
                            this.hotelAccount,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: (){
                  print('系统设置');
                  Navigator.pushNamed(context, '/sysset');
                },
                child:
                Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)
                  )
                ),
                child: Row(
                  children: [
                    Icon(
                        Icons.settings,
                    color: Colors.white,
                    ),
                    SizedBox(width: 3,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('设置',style: TextStyle(color: Colors.white),),
                        // Text('data1',style: TextStyle(color: Colors.white),),
                      ],
                    )
                  ],
                ),
              ),),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              PubTextBtn('¥ 0.00','今售餐券'),
              PubTextBtn('0','预计过夜'),
              PubTextBtn('0','有效拓客'),
            ],
          ),
        ],
      ),
    );
  }
}

class PubTextBtn extends StatelessWidget {
  final String icon;
  final String str;
  const PubTextBtn( this.icon,this.str );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          onTap: (){
            // Navigator.push(context, route);
          },
          child: Column(
            children: [
              Text(icon,
                style: TextStyle(
                    fontSize: 16.0,
                  color: Colors.white
                ),),
              SizedBox(height: 5.0,),
              Text(str,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white
                ),)
            ],
          ),
        ));
  }
}
