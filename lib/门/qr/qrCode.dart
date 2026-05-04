import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/http/base_response.dart';
import '/http/pub.dart';
import '/utils.dart';
import '../../V/showDefineAlertWidget.dart';

class QrCodePage extends StatefulWidget {
  final String? id;
  final String? roomNumber;
  QrCodePage(this.id, this.roomNumber);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String jsonStr = '';

  void _getData([id]) async {
    String hotelId = await PubMoudle.getHotelId();
    var data =
        await PubMoudle().httpRequest('', 'get', '/api/hotel/$hotelId/room/$id/qrcode', {"deviceIdent": Utils.ANDROID_UUID});
    if (data == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ShowDefineAlertWidget(pushLoginVC, '温馨提示', '登陆已过期，请重新登陆');
          });
      return;
    }
    // print(data.data);
    BaseResponse baseModel = BaseResponse.fromJson(data.data);
    if (baseModel.code == 200) {
      String jsonString = baseModel.data.toString();
      // print(jsonString);
      if (mounted) {
        setState(() {
          jsonStr = jsonString;
        });
      }
    }
  }

  pushLoginVC() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("房间${widget.roomNumber}"),
        centerTitle: true,
      ),
      body: new Center(
        child:
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,  //居中
            //   children: [
            //     SizedBox(height: 120,),
            //     Text("授权二维码"),
            //     SizedBox(height: 20,),

            jsonStr.isNotEmpty
                ? SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 二维码
                        QrImageView(
                          data: jsonStr,
                          size: 300.0,
                        ),
                        // 中间的网络图片 Logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            "https://zhengxin-pub.cdn.bcebos.com/logopic/6e832d952ad4d130b5381eacf49f49d3_fullsize.jpg?x-bce-process=image/resize,m_lfit,w_200",
                            width: 60, // logo 大小
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),

        //   ],
        // ),
      ),
    );
  }
}

// version	int	QrVersions.auto或者介于1和40之间的值。有关限制和详细信息，请访问http://www.qrcode.com/en/about/version.html。
// errorCorrectionLevel	int	定义的值QrErrorCorrectLevel。例如：QrErrorCorrectLevel.L。
// size	double	二维码的（方形）大小。如果没有给出，将使用最短大小约束自动调整大小。
// padding	EdgeInsets	二维码内边距
// backgroundColor	Color	背景颜色（默认为无）
// errorStateBuilder	QrErrorBuilder	允许您Widget在呈现QR码时出现错误时显示错误状态（例如：版本太低，输入太长等）
// foregroundColor	Color	前景色（默认为黑色）
// gapless	bool	添加一个额外的像素以防止间隙（默认为true）
// constrainErrorBounds	bool	如果为true，则错误Widget将被限制为将要绘制QR码的平方。如果为false，则错误状态Widget将增大/缩小到所需的任何大小
// embeddedImage	ImageProvider	个ImageProvider限定的图像以在QR码的中心重叠
// embeddedImageStyle	QrEmbeddedImageStyle	用于设置嵌入图像样式的属性
// embeddedImageEmitsError	bool	如果为true，则任何加载嵌入图像的失败都将触发errorStateBuilder或呈现为空Container。如果为false，则将呈现QR码，并且将忽略嵌入的图像
