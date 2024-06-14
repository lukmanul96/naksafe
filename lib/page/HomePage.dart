import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:nakcare_app/BluetoothClass.dart';
import 'package:nakcare_app/controller/provider.dart';
import 'package:nakcare_app/page/AlertTimer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;
  bool isSwitched = false;
  bool _hasEverConnected = false;
  final ValueNotifier<bool> _isAlarmOn = ValueNotifier<bool>(false);

  BluetoothClass bluetooth = BluetoothClass();
  BluetoothDevice? _device;
  bool _connected = false;
  bool _disconnectFlag = false;
  String _status = "No child detected";
  final String allowedDeviceAddress =
      '98:D3:41:FD:53:A0'; // Replace with your allowed device's address

  void onTabTapped(int index) {
    setState(() {
      myIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetooth.bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    bluetooth.dispose();
    super.dispose();
  }

  void _connect() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      print("Bonded devices: ${devices.length}"); // Debug print
    } catch (e) {
      print("Error: $e");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.grey[50],
          title: const Text(
            "Select Your NakSafe Kit :",
            style: TextStyle(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.grey[60],
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.maxFinite,
            child: ListView(
              children: devices.map((device) {
                return ListTile(
                  title: Text(device.name ?? "Unknown"),
                  subtitle: Text(device.address),
                  onTap: () {
                    setState(() {
                      _device = device;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    ).then((_) async {
      if (_device != null) {
        print("Connecting to device: ${_device!.address}"); // Debug print
        await bluetooth.connect(_device!.address, allowedDeviceAddress);
        setState(() {
          _connected = bluetooth.isConnected;
          _hasEverConnected = true;
        });
        if (_connected) {
          print("Connected to device: ${_device!.address}"); // Debug print
          bluetooth.onDataReceived.listen((data) {
            print('Data received: $data'); // Debug print
            _processData(data);
            _isAlarmOn.value = false;
          });
        }
      }
    });
  }

  void _disconnect() {
    print("Disconnecting from device"); // Debug print
    bluetooth.disconnect();
    setState(() {
      _connected = false;
      _disconnectFlag = true;
      _status = "Your kit is disconnected. Please check if your child is safe.";
      _isAlarmOn.value = true;
    });
  }

  void _showAddressNotAllowedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Connection Rejected"),
          content: const Text("The selected device is not allowed to connect."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _processData(String data) {
    // Print the data for debugging purposes
    print('Processing data: $data');

    // Simplified data processing
    setState(() {
      if (data.contains("No pressure")) {
        _status = "No child detected";
      } else if (data.contains("Light touch") ||
          data.contains("Light movement") ||
          data.contains("Medium movement")) {
        _status = "Child detected";
      } else if (data.contains("Big movement")) {
        _status = "Child detected";
      } else {
        _status = "No child detected";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Access name and avatarImage
    final parentName = userProvider.parentName;
    final childName = userProvider.childName;
    final avatarImage = userProvider.avatarImage;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
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
                                        title: Text('Your kit is connected.'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ClipOval(
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: Color(0xFF3186C6),
                          size: 35,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 20),
                  child: Row(
                    children: [
                      Text(
                        _connected
                            ? 'Your kit is connected'
                            : 'Your kit is not connected',
                        style: const TextStyle(
                          color: Color(0xFF3186C6),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundColor: _connected ? Colors.green : Colors.red,
                        radius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: (parentName == null || parentName.isEmpty)
                                ? "Owner's Car"
                                : "$parentName's Car",
                            style: TextStyle(
                              color: Color(0xFF3186C6),
                              fontFamily: 'Manrope',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, top: 40, right: 20, bottom: 40),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF3186C6),
                                radius: 60,
                                backgroundImage: avatarImage != null
                                    ? FileImage(avatarImage)
                                    : null,
                                child: Icon(
                                  Icons.child_care,
                                  size: 50,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            const SizedBox(width: 40), // Adjusted spacing
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      childName ?? 'Child Name',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    width: double.infinity,
                                    height: 100,
                                    child: Text(
                                      _status,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Text(
                                        _connected ? "On" : "Off",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(width: 14), // Adjusted spacing
                                      Switch(
                                        inactiveThumbColor: Color(0xFF3186C6),
                                        activeColor: Color(0xFF3186C6),
                                        value: _connected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value) {
                                              _connect();
                                            } else {
                                              _disconnect();
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: !_connected &&
                          _hasEverConnected // Check if the Bluetooth is not connected and has ever been connected
                      ? Container(
                          width: 100,
                          height: 180,
                          child: AlertTimer(),
                        )
                      : ValueListenableBuilder<bool>(
                          valueListenable: _isAlarmOn,
                          builder: (context, value, child) {
                            return SwitchListTile(
                              inactiveThumbColor:
                                  Color.fromARGB(255, 26, 44, 58),
                              activeColor: Color(0xFF3186C6),
                              title: const Text(
                                'Turn on if you left your child attended with other passenger.',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              value: value,
                              onChanged: (bool newValue) {
                                _isAlarmOn.value = newValue;
                                // TODO: Implement set alarm ringtone functionality
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
