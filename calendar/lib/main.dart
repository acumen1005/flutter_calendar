import 'package:flutter/material.dart';
import 'dateHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final weekLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  DateTime curDateTime;
  
  DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    curDateTime = DateTime.now();
    selectedDateTime = curDateTime;
    print('dateTime: ${DateTime.now().weekday}');
  }

  void _onDidClickLeft() {
    print('click left');
    setState(() {
      this.curDateTime = DateHelper.previousMonth(this.curDateTime);
    });
  }
  
  void _onDidClickRight() {
    print('click right');
    setState(() {
      this.curDateTime = DateHelper.nextMonth(this.curDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                height: 48,
                child: Row(
                  children: [
                    FlatButton(
                      child: Icon(Icons.keyboard_arrow_left),
                      onPressed: _onDidClickLeft,
                    ),
                    Spacer(),
                    Text(
                      '${DateHelper.genBarTitle(this.curDateTime)}',
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF444136)
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      child: Icon(Icons.keyboard_arrow_right),
                      onPressed: _onDidClickRight,
                    )
                  ],
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top:0, left:8, right:8, bottom:8),
              child: Container(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weekLabels.map((e) { 
                    return Text(
                      e,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                        color: Color(0xFF9C9C9C)
                        )
                      );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight - 300,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 42,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth;
                      BoxShadow boxShadow = null;
                      Color itemBgColor = Colors.transparent;
                      TextStyle textStyle = TextStyle(
                        color: Color(0xFF070707),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontSize: 20,
                      );
                      int dayText = 0;
                      final now = this.curDateTime;
                      final weekIndex = DateHelper.weekIndexOfFirstDayInMonth(now);
                      final monthDaysCount = DateHelper.daysCountOfMonth(now);
                      final lastMonthDaysCount = DateHelper.daysCountOfPreviousMonth(now);
                      if (index < 7 && index < weekIndex)  {
                        dayText = lastMonthDaysCount - (weekIndex - 1 - index);
                        textStyle = textStyle.merge(TextStyle(
                          color: Color(0xFFC8C8C8),
                          fontWeight: FontWeight.w400
                        ));
                      } else {
                        final day = index - weekIndex + 1;
                        if (day <= monthDaysCount) {
                          dayText = day;
                          if (day == now.day) {
                            textStyle = textStyle.merge(TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ));
                            itemBgColor = Colors.black;
                            boxShadow = BoxShadow(
                              color: Colors.grey[350],
                              offset: Offset(2.0,6.0),
                              blurRadius: 4.0
                            );
                          }
                        } else {
                          dayText = day - (monthDaysCount);
                          textStyle = textStyle.merge(TextStyle(
                            color: Color(0xFFC8C8C8),
                            fontWeight: FontWeight.w400
                          ));
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          final updateDay = index - weekIndex + 1;
                          setState(() {
                            this.curDateTime = DateHelper.updateDay(this.curDateTime, updateDay);
                          });
                          
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              '$dayText',
                              style: textStyle
                              )
                            ),
                          decoration: BoxDecoration(
                            color: itemBgColor,
                            borderRadius: BorderRadius.circular(itemWidth/2.0),
                            boxShadow: boxShadow == null ? [] : [boxShadow]
                          )
                        )
                      );
                  });
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8
                ),
              ),
            )
          ],
        )
      )
    );
  }
}