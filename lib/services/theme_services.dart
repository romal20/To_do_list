/*
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }


}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeService extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _themesCollection = FirebaseFirestore.instance.collection('themes');

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // Get theme from local storage
  ThemeMode get theme =>
      _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // Switch theme locally and save to local storage
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    _saveThemeToFirestore(!_loadThemeFromBox());
  }

  // Save theme preference to local storage
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Save theme preference to Firestore
  Future<void> _saveThemeToFirestore(bool isDarkMode) async {
    try {
      await _themesCollection.doc('theme').set({
        _key: isDarkMode,
      });
    } catch (e) {
      print('Error saving theme to Firestore: $e');
    }
  }

  // Load theme preference from Firestore
  Future<bool> _loadThemeFromFirestore() async {
    try {
      var docSnapshot = await _themesCollection.doc('theme').get();
      return docSnapshot.exists ? docSnapshot[_key] ?? false : false;
    } catch (e) {
      print('Error loading theme from Firestore: $e');
      return false;
    }
  }

  // Get theme mode from Firestore
  Future<ThemeMode> getThemeFromFirestore() async {
    bool isDarkMode = await _loadThemeFromFirestore();
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}