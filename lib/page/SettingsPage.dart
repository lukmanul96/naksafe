import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final ValueNotifier<bool> _isBluetoothOn = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isAlarmOn = ValueNotifier<bool>(false);
  final ValueNotifier<int> _alarmTime = ValueNotifier<int>(5);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nak',
                                style: TextStyle(
                                  color: Color(0xFF3186C6),
                                  fontFamily: 'Manrope',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              TextSpan(
                                text: 'Safe',
                                style: TextStyle(
                                  color: Color(0xFFFBBA63),
                                  fontFamily: 'Manrope',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Align(
                            alignment: Alignment.topRight,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                width: 300,
                                margin:
                                    const EdgeInsets.only(top: 60, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView(
                                  padding: const EdgeInsets.all(8.0),
                                  shrinkWrap: true,
                                  children: const <Widget>[
                                    ListTile(
                                      leading:
                                          Icon(Icons.notification_important),
                                      title: Text('Notification 1'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const ClipOval(
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: Color(0xFF3186C6),
                        size: 35,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 60),
              Container(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isBluetoothOn,
                  builder: (context, value, child) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      inactiveThumbColor: Color(0xFF3186C6),
                      activeColor: Color(0xFF3186C6),
                      title: const Text('Enable bluetooth auto-reconnect'),
                      value: value,
                      onChanged: (bool newValue) {
                        _isBluetoothOn.value = newValue;
                        // TODO: Implement Bluetooth reconnect functionality
                      },
                    );
                  },
                ),
              ),
              Container(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isAlarmOn,
                  builder: (context, value, child) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      inactiveThumbColor: Color(0xFF3186C6),
                      activeColor: Color(0xFF3186C6),
                      title: const Text('Enable alarm notifications'),
                      value: value,
                      onChanged: (bool newValue) {
                        _isAlarmOn.value = newValue;
                        // TODO: Implement set alarm ringtone functionality
                      },
                    );
                  },
                ),
              ),
              Container(
                child: ListTile(
                  title:
                      const Text('Choose alert time for alarm notifications'),
                  trailing: ValueListenableBuilder<int>(
                    valueListenable: _alarmTime,
                    builder: (context, value, child) {
                      return DropdownButton<int>(
                        value: value,
                        items: <int>[5, 10, 15, 20, 25, 30]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value minutes'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            _alarmTime.value = newValue;
                            // TODO: Implement set alarm ringtone functionality
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
