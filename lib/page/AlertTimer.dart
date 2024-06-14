import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nakcare_app/controller/local_notification.dart';

class AlertTimer extends StatefulWidget {
  @override
  _AlertTimerState createState() => _AlertTimerState();
}

class _AlertTimerState extends State<AlertTimer> {
  int _counter = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    LocalNotificationService.init();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          LocalNotificationService.showBasicNotification();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$_counter',
        style: TextStyle(
            fontSize: 48, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }
}
