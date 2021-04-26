import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static final String routeName = "/profilePage";
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var inputDeco = InputDecoration(
    labelStyle: TextStyle(color: primary2),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: primary2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: primaryLight,
        width: 2.0,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: mainContainerBoxDecor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: primary2, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/account.png'),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: "Alexia Johnson",
                  cursorColor: primary2,
                  decoration: inputDeco.copyWith(labelText: "Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  initialValue: "9988998899",
                  cursorColor: primary2,
                  decoration: inputDeco.copyWith(labelText: "Contact Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: TextFormField(
                  cursorColor: primary2,
                  initialValue: "alexia.johnson@gmail.com",
                  decoration:
                      inputDeco.copyWith(labelText: "E-Mail", hintText: ""),
                ),
              ),
              getButton("Save", Icons.save, () {})
            ],
          ),
        ),
      ),
    );
  }
}
