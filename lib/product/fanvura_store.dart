import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FanvuraStore extends ChangeNotifier {
  List<dynamic> logs = [];

  Future<void> load(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('fanvura_logs')) {
      logs = jsonDecode(jsonStr)['logs'] ?? [];
      await save();
    } else {
      logs = jsonDecode(prefs.getString('fanvura_logs')!);
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fanvura_logs', jsonEncode(logs));
  }
}
