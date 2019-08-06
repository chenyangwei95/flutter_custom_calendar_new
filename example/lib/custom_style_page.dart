import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';


class CustomStylePage extends StatefulWidget {
  CustomStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CustomStylePageState createState() => _CustomStylePageState();
}

class _CustomStylePageState extends State<CustomStylePage> {
  String text;

  CalendarController controller;

  @override
  void initState() {
    text = "${DateTime.now().year}年${DateTime.now().month}月";

    controller = new CalendarController(weekBarItemWidgetBuilder: () {
      return CustomStyleWeekBarItem();
    }, dayWidgetBuilder: (dateModel) {
      return CustomStyleDayWidget(dateModel);
    });

    controller.addMonthChangeListener(
      (year, month) {
        setState(() {
          text = "$year年$month月";
        });
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                new Text(text),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
              calendarController: controller,
            ),
            new Text(
                "自定义创建Item\n选中的时间:\n${controller.getSingleSelectCalendar().toString()}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCustomDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    bool isWeekend = dateModel.isWeekend;
    bool isInRange = dateModel.isInRange;

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend ? Colors.blue : Colors.black,
              fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange
                  ? Colors.grey
                  : isWeekend ? Colors.blue : Colors.grey,
              fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    //绘制背景
    Paint backGroundPaint = new Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}
