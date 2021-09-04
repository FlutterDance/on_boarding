
import 'package:flutter/material.dart';

/// 手表页面模型
class WatchPageModel {

  /// 表图片
  String image;

  /// 描述视图
  Widget description;

  /// 背景颜色
  Color color;

  WatchPageModel({
    required this.image,
    required this.color,
    required this.description,
  });

  /// 预先准备好的 Apple Watch 数据源（模型数组）
  static List<WatchPageModel> list() {
    return  [
      WatchPageModel(
        image: 'assets/images/ia_100000028.png',
        color: Colors.black,
        description: Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            children: [
              TextSpan(text: '健康的未来，\n现在戴上。\n\n'),
              TextSpan(
                  text: 'RMB 3199 起',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      WatchPageModel(
        image: 'assets/images/icon_watch_1.png',
        color: Color(0xff5c6bc0),
        description: WatchPageModel.descriptionWidget(
            model: '编织单圈表带\n\n',
            price: 3199,
            intro: '铝金属表壳十分轻盈，采用 100% 再生的航空级铝金属制成。\n\n编织单圈表带采用再生纱与硅胶丝交错编织而成，无表扣式弹性设计令佩戴格外舒适。'
        ),
      ),
      WatchPageModel(
        image: 'assets/images/icon_watch_2.png',
        color: Color(0xffff9100),
        description: WatchPageModel.descriptionWidget(
            model: '回环式运动表带\n\n',
            price: 3199,
            intro: '铝金属表壳十分轻盈，采用 100% 再生的航空级铝金属制成。\n\n编织单圈表带采用再生纱与硅胶丝交错编织而成，无表扣式弹性设计令佩戴格外舒适。'
        ),
      ),
      WatchPageModel(
        image: 'assets/images/icon_watch_3.png',
        color: Color(0xffE8B896),
        description: WatchPageModel.descriptionWidget(
            model: '运动型表带\n\n',
            price: 3199,
            intro: '铝金属表壳十分轻盈，采用 100% 再生的航空级铝金属制成。\n\n运动型表带采用高性能 Fluoroelastomer 材料，坚韧耐用却又异常柔软，并搭配创新的按扣加收拢式表扣。'
        ),
      ),
      WatchPageModel(
        image: 'assets/images/icon_watch_4.png',
        color: Color(0xff4E5160),
        description: WatchPageModel.descriptionWidget(
            model: '皮制回环形表带\n\n',
            price: 3199,
            intro: '不锈钢表壳经久耐用，表层经过抛光处理，呈现镜面般闪亮的光泽。\n\n皮制回环形表带采用威尼斯皮革手工打造而成，内藏磁体，只需将表带绕于腕间，就能与手腕完美贴合，简洁利落。'
        ),
      ),
    ];
  }

  /// 底部描述视图
  static Widget descriptionWidget({
    required String model,
    required int price,
    required String intro,
  }) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(text: model),
          TextSpan(
              text: 'RMB $price 起\n\n',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              )),
          TextSpan(
            text:intro,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          )
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}




