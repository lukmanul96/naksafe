import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothClass {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection? connection;
  bool isConnected = false;
  String buffer = '';
  bool isAutoReconnect = true;
  int reconnectCounter = 0;
  final int maxTryReconnect = 5;
  String? deviceAddress;

  StreamSubscription<BluetoothState>? _stateSubscription;
  StreamController<String> _dataStreamController = StreamController<String>();

  BluetoothClass() {
    // Listen for Bluetooth state changes
    _stateSubscription = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;
    });
  }

  Future<void> connect(String address, String allowedDeviceAddress) async {
    if (address != allowedDeviceAddress) {
      print('Connection rejected: Address $address is not allowed');
      return;
    }

    try {
      print('Attempting to connect to $address');
      connection = await BluetoothConnection.toAddress(address);
      isConnected = true;
      print('Connected to the device: $address'); // Debug print
      connection!.input?.listen((Uint8List data) {
        String dataString = String.fromCharCodes(data);
        buffer += dataString; // Append data to buffer
        int endIndex;
        while ((endIndex = buffer.indexOf('\n')) != -1) {
          String line = buffer.substring(0, endIndex).trim();
          buffer = buffer.substring(endIndex + 1);
          print('Received raw line: $line'); // Debug print
          _dataStreamController.add(line);
        }
      }).onDone(() {
        print('Disconnected by remote request');
        disconnect();
      });
    } catch (exception) {
      print('Cannot connect, exception occurred: $exception');
    }
  }

  void disconnect() {
    connection?.dispose();
    connection = null;
    isConnected = false;
    print('Disconnected from the device');
  }

  void _handleReconnection(String allowedDeviceAddress, String address) {
    if (isAutoReconnect && reconnectCounter < maxTryReconnect) {
      reconnectCounter++;
      print('Reconnecting attempt #$reconnectCounter/$maxTryReconnect');
      Future.delayed(const Duration(seconds: 5), () {
        if (bluetoothState == BluetoothState.STATE_ON && !isConnected) {
          connect(address, allowedDeviceAddress);
        }
      });
    }
  }

  void dispose() {
    _stateSubscription?.cancel();
    _dataStreamController.close();
    connection?.dispose();
  }

  Stream<String> get onDataReceived => _dataStreamController.stream;
}
