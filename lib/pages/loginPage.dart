import 'package:chef_choice/pages/otpPage.dart';
import 'package:chef_choice/pages/registerPage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/MyClipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = "/loginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController tec_mobile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tec_mobile = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.topLeft,
                        colors: [
                      primary2,
                      primaryLight,
                      primaryLight.withOpacity(0.7)
                    ])),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 60, right: 60, bottom: 30),
                        child: Container(
                          height: width / 2,
                          width: width / 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryLight,
                                blurRadius: 15.0,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: primary2,
                                blurRadius: 15.0,
                                offset: Offset(-4, -4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage("images/logo.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Form(
                      key: _key,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: primary2.withOpacity(0.35),
                                  blurRadius: 8.0,
                                  offset: Offset(3, 3),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: tec_mobile,
                                  decoration: textfield1Deco.copyWith(
                                    prefixIcon:
                                        Icon(Icons.phone, color: primary2),
                                    hintText: "Enter you mobile number",
                                    labelText: "Mobile Number",
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Mobile number field cannot be empty!";
                                    else if (value.length < 10)
                                      return "Mobile number must contain 10 digits!";
                                    else
                                      return null;
                                  },
                                ),
                                Container(
                                  child: isLoading
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Container(),
                                ),
                                SizedBox(height: 30),
                                getButton(
                                  "Get OTP",
                                  Icons.lock_clock,
                                  () async {
                                    if (_key.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await Provider.of<ShopDataProvider>(
                                              context,
                                              listen: false)
                                          .checkMobile(tec_mobile.text)
                                          .then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (value)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OtpPage(
                                                      tec_mobile.text)));
                                        else
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterPage(
                                                          tec_mobile.text)));
                                      }).catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "An error has Occurred"),
                                                content: Text(e.toString()),
                                              );
                                            });
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
SizedBox(height: 30),
                              TextFormField(
                                decoration: textfield1Deco.copyWith(
                                  prefixIcon: Icon(Icons.lock, color: primary2),
                                  hintText: "Enter your password",
                                  labelText: "Password",
                                ),
                                obscureText: true,
                              ),
*/
