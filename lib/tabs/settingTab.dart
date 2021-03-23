import 'package:flutter/material.dart';

class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Settings Tab"),
      ),
    );
  }
}
