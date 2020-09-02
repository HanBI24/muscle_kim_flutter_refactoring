import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:muscle_kim_flutter_refactoring/widget/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimePickerScreen extends StatefulWidget {
  String title;
  TimePickerScreen({this.title});

  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  DateTime _dateTime = DateTime.now();
  int hour = 0, minute = 0;
  int setHour = 0, setMinute = 0;
  String isDay = '오늘';
  String am_pm;
  SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    saveTime();
  }

  void saveTime() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      hour = (_preferences.getInt('hour') ?? 0);
      minute = (_preferences.getInt('minute') ?? 0);
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('muscle Kim'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            timePicker12H(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                am_pm.toString().padLeft(2, '0') +
                    ':' +
                    _dateTime.hour.toString().padLeft(2, '0') +
                    ':' +
                    _dateTime.minute.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    setHour = _dateTime.hour;
                    setMinute = _dateTime.minute;
                    hour = _dateTime.hour - DateTime.now().hour;
                    minute = _dateTime.minute - DateTime.now().minute;

                    if (hour < 0) {
                      hour += 24;
                      if (minute < 0) {
                        hour -= 1;
                        minute += 60;
                      }
                    }
                    if (minute < 0) {
                      hour += 23;
                      minute += 60;
                      if (hour > 23) {
                        hour -= 24;
                      }
                    }
                    startTimer();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('추가'),
                  ],
                ),
              ),
            ),
            Container(
              child:
                  Text('$hour'.toString() + '시간 ' + '$minute'.toString() + '분'),
            )
          ],
        ),
      ),
    );
  }

  void startTimer() async {
    Timer _timer;
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (minute < 1 && hour < 1) {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return LocalNotifications();
                }));
            timer.cancel();
          } else {
            if (hour >= 0) {
              if (minute > 0) {
                minute -= 1;
              } else {
                minute = 59;
                hour -= 1;
                _preferences.setInt('hour', hour);
                _preferences.setInt('minute', minute);
              }
            }
          }
        },
      ),
    );
  }

  Widget timePicker12H() {
    return TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.orange),
      highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.blue),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          if (time.hour >= 12)
            am_pm = "PM";
          else
            am_pm = "AM";
          _dateTime = time;
        });
      },
    );
  }
}
