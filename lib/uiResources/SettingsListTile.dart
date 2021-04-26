import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function onTap;

  SettingsListTile(
      {@required this.title, @required this.iconData, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        tileColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
        ),
        leading: Icon(
          iconData,
          color: primary2,
        ),
        onTap: onTap,
      ),
    );
  }
}
