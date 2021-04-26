import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  static final String routeName = "/changePassPage";

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isObscured = true;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary2),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
        child: Form(
          child: Center(
            child: Container(
              decoration: mainContainerBoxDecor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: primary2,
                      obscureText: isObscured,
                      decoration: inputDeco.copyWith(
                        labelText: "Password",
                        hintText: "Enter your password",
                        suffixIcon: IconButton(
                          icon: isObscured
                              ? Icon(Icons.visibility, color: primary2)
                              : Icon(Icons.visibility_off, color: primary2),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: primary2,
                      obscureText: isObscured,
                      decoration: inputDeco.copyWith(
                        labelText: "Confirm Password",
                        hintText: "Confirm your password",
                        suffixIcon: IconButton(
                          icon: isObscured
                              ? Icon(Icons.visibility, color: primary2)
                              : Icon(Icons.visibility_off, color: primary2),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getButton(
                        "Change Password", Icons.lock_outline_rounded, () {}),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
