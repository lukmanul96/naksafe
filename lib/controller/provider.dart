import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  File? _avatarImage;
  String? _parentname;
  String? _childname;
  double? _childweight;

  File? get avatarImage => _avatarImage;
  String? get parentName => _parentname;
  String? get childName => _childname;
  double? get childWeight => _childweight;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/avatar.png');
      _avatarImage = savedImage;
      notifyListeners();
    }
  }

  Future<void> loadAvatarImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final savedImage = File('${appDir.path}/avatar.png');
    if (await savedImage.exists()) {
      _avatarImage = savedImage;
      notifyListeners();
    }
  }

  Future<void> saveparentName(String parentName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parentname', parentName);
    _parentname = parentName;
    notifyListeners();
  }

  Future<void> loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _parentname = prefs.getString('parentname') ?? '';
    notifyListeners();
  }

  Future<void> savechildName(String childName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('childname', childName);
    _childname = childName;
    notifyListeners();
  }

  Future<void> loadchildWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _childweight = double.tryParse(prefs.getString('childweight') ?? '');
    notifyListeners();
  }

  Future<void> savechildWeight(String childWeight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('childweight', childWeight);
    _childweight = double.tryParse(childWeight);
    notifyListeners();
  }

  Future<void> loadchildName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _childname = prefs.getString('childname') ?? '';
    notifyListeners();
  }
}
