import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/registerPage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/MyClipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static final String routeName = "/loginPage";

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
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
                          colors: [primary2, primary1, primary])),
                ),
              ),
              Container(
                height: height,
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
                                color: primary,
                                blurRadius: 15.0,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: primary1,
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
                    Padding(
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
                                decoration: textfield1Deco.copyWith(
                                  prefixIcon:
                                      Icon(Icons.phone, color: primary2),
                                  hintText: "Enter you mobile number",
                                  labelText: "Mobile Number",
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                decoration: textfield1Deco.copyWith(
                                  prefixIcon: Icon(Icons.lock, color: primary2),
                                  hintText: "Enter your password",
                                  labelText: "Password",
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getButton("Login", Icons.login, () {
                                    Navigator.pushNamed(
                                        context, HomePage.routeName);
                                  }),
                                  getButton(
                                    "Register",
                                    Icons.person_add,
                                    () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 2000),
                                            pageBuilder: (_, __, ___) =>
                                                RegisterPage(),
                                          ));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
