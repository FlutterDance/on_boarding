import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'watch_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      home: FlowPager(),
    ),
  );

}

class FlowPager extends StatefulWidget {
  @override
  _FlowPagerState createState() => _FlowPagerState();
}

class _FlowPagerState extends State<FlowPager> {
  ValueNotifier<double> _animationProgress = ValueNotifier(0.0);
  final _button = GlobalKey();
  final _pageController = PageController();

  /// 数据源
  final _watchPageList = WatchPageModel.list();

  @override
  void initState() {
    _pageController.addListener(() {
      _animationProgress.value = _pageController.page!;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationProgress,
              builder: (_, __) => CustomPaint(
                painter: FlowPainter(
                  context: context,
                  animationProgress: _animationProgress,
                  target: _button,
                  colors: List.generate(_watchPageList.length, (index) => _watchPageList[index]
                      .color),
                ),
              ),
            ),

            // PageView
            PageView.builder(
              controller: _pageController,
              itemCount: _watchPageList.length,
              itemBuilder: (ctx, index) {
                return _pageAtIndex(index);
              },
            ),
            // Anchor Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ClipOval(
                  child: AnimatedBuilder(
                    animation: _animationProgress,
                    builder: (_, __) {
                      /// 动画进度
                      final progress =
                          _animationProgress.value - _animationProgress.value.floor();

                      /// 按钮箭头透明度
                      double opacity = 0;

                      /// 箭头图标位置
                      double iconPosition = 0;

                      /// 背景颜色索引
                      int colorIndex;

                      if (progress < 0.5) {
                        opacity = (progress - 0.5) * -2;
                        iconPosition = 80 * -progress;
                        colorIndex = _animationProgress.value.floor() + 1;
                      } else {
                        colorIndex = _animationProgress.value.floor() + 2;
                        iconPosition = -80;
                      }
                      if (progress > 0.9) {
                        iconPosition = -250 * (1 - progress) * 10;
                        opacity = (progress - 0.9) * 10;
                      }
                      colorIndex = colorIndex % _watchPageList.length;

                      return GestureDetector(
                        onTap: () {
                          if (_pageController.page!.toInt() >= _watchPageList.length -
                          1) {
                            return;
                          } else {
                          _pageController.nextPage(duration: Duration
                            (milliseconds: 540), curve: Curves.easeInOut);
                          }
                        },
                        child: SizedBox(
                          key: _button,
                          width: 64,
                          height: 64,
                          child: Transform.translate(
                            offset: Offset(iconPosition, 0),
                            child: Container( /// TODO: 2
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _watchPageList[colorIndex].color,
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(opacity),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            _appleWatchLogo(),
          ],
        ),
      ),
    );
  }

  // Widget _tempPage(int index) {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: Container(
  //       width: double.infinity,
  //       height: double.infinity,
  //       color: _watchPageList[index].color,
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 200),
  //       child: Text(
  //         'PAGE $index',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontSize: 50,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w900,
  //         ),
  //       ),
  //     ),
  //     ),
  //   );
  // }

  /// 顶部标题 logo
  Widget _appleWatchLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              children: [
                TextSpan(
                    text: '',
                    style: TextStyle(
                      fontSize: 38,
                    )),
                TextSpan(text: 'WATCH\n'),
                TextSpan(
                    text: 'SERIES 6',
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ],
            ),
            textAlign: TextAlign.center,
          )),
    );
  }

  Widget _pageAtIndex(int index) {
    WatchPageModel item = _watchPageList[index];
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 180),
          child: Column(
            children: [
              Image(
                width: 280,
                height: 280,
                image: AssetImage(item.image),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: item.description,
              ),
            ],
          ),
        ),
      );
  }
}


/// 核心绘制（主要是根据动画进度来渲染画面）
class FlowPainter extends CustomPainter {


  final BuildContext context;

  /// 动画进度
  final ValueNotifier<double> animationProgress;

  /// 指向底部按钮的 key
  final GlobalKey target;

  /// 变化的颜色列表
  final List<Color> colors;


  RenderBox? _renderBox;

  FlowPainter(
      {required this.context,
      required this.animationProgress,
      required this.target,
      required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final screen = MediaQuery.of(context).size;
    if (_renderBox == null) {
      _renderBox = target.currentContext!.findRenderObject() as RenderBox?;
    }
    // if (_renderBox == null) return;
    /// 上一页
    final page = animationProgress.value.floor();
    /// 动画进度（手势拖拽百分比）
    final progress = animationProgress.value - page;
    
    final targetPosition = _renderBox!.localToGlobal(Offset.zero);
    
    final xScale = screen.height * 8, yScale = xScale / 2;
    
    /// 计算当前动画曲线，主要用于决定动画在不同时机的速率
    var curvedValue = Curves.easeInOut.transformInternal(progress);

    /// 逆转动画曲线，作用同上
    final reverseValue = 1 - curvedValue;

    Paint buttonPaint = Paint(), backgroundPaint = Paint();
    Rect buttonRect, backgroundRect = Rect.fromLTWH(0, 0, screen.width, screen.height);

    if (progress < 0.5) {
      backgroundPaint..color = colors[page % colors.length];
      buttonPaint..color = colors[(page + 1) % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPosition.dx - (xScale * curvedValue), //left
        targetPosition.dy - (yScale * curvedValue), //top
        targetPosition.dx + _renderBox!.size.width * reverseValue, //right
        targetPosition.dy + _renderBox!.size.height + (yScale * curvedValue), //bottom
      );
    } else {
      backgroundPaint..color = colors[(page + 1) % colors.length];
      buttonPaint..color = colors[page % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPosition.dx + _renderBox!.size.width * reverseValue, //left
        targetPosition.dy - yScale * reverseValue, //top
        targetPosition.dx + _renderBox!.size.width + xScale * reverseValue, //right
        targetPosition.dy + _renderBox!.size.height + yScale * reverseValue, //bottom
      );
    }

    /// 绘制背景
    canvas.drawRect(backgroundRect, backgroundPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, Radius.circular(screen.height)),
      buttonPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
