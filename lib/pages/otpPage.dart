import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/MyClipper.dart';
import 'package:chef_choice/uiResources/PageConstant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  static final String routeName = "/otpPage";
  final mobileNo;
  final int goToPage;
  OtpPage({@required this.mobileNo, @required this.goToPage});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController tec_otp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tec_otp = TextEditingController();
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
                        begin: Alignment.centerRight, end: Alignment.topLeft, colors: [primary2, primaryLight, primaryLight.withOpacity(0.7)])),
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
                        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 30),
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
                            backgroundImage: AssetImage("images/aloo_kanda_icon.png"),
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
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
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
                                  controller: tec_otp,
                                  decoration: textfield1Deco.copyWith(
                                    prefixIcon: Icon(Icons.lock_clock, color: primary2),
                                    hintText: "Enter you OTP number",
                                    labelText: "OTP",
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "OTP field cannot be empty!";
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: isLoading ? Center(child: CircularProgressIndicator()) : Container(),
                                ),
                                SizedBox(height: 10),
                                getButton(
                                  "Login",
                                  Icons.login,
                                  () async {
                                    if (_key.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      //Check otp, if valid, session will be recieved or go to catchError(Outer)
                                      await Provider.of<ShopDataProvider>(context, listen: false)
                                          .checkOTP(widget.mobileNo, tec_otp.text)
                                          .then((userData) async {
                                        //=================================================================
                                        //session is retrieved, save session,

                                        await Provider.of<SharedPrefProvider>(context, listen: false).save(userData).then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (value) {
                                            if (widget.goToPage == PageConstant.TimSlotPage) Navigator.pushNamed(context, TimeSlotPage.routeName);
                                            if (widget.goToPage == PageConstant.SettingPage)
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(builder: (context) => HomePage(2)), (route) => false);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Something went wrong!"),
                                                  content: Text("Session Not Saved!"),
                                                );
                                              },
                                            );
                                          }
                                        });

                                        //=================================================================
                                      }).catchError(
                                        //catchError(Outer)
                                        (e) {
                                          setState(
                                            () {
                                              isLoading = false;
                                            },
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Something went wrong!"),
                                                content: Text(e.toString()),
                                              );
                                            },
                                          );
                                        },
                                      );
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
