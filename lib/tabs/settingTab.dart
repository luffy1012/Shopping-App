import 'dart:ui';

import 'package:chef_choice/pages/aboutUsPage.dart';
import 'package:chef_choice/pages/changePasswordPage.dart';
import 'package:chef_choice/pages/loginPage.dart';
import 'package:chef_choice/pages/ordersPage.dart';
import 'package:chef_choice/pages/profilePage.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/SettingsListTile.dart';
import 'package:chef_choice/uiResources/WebViewCotainer.dart';
import 'package:chef_choice/uiResources/headCurvedContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  bool isLoading = false;
  Future _checkLogin;
  Future _userFutureData;
  Future _pageFutureData;
  @override
  void initState() {
    // TODO: implement initState
    print("in init settingTab");
    _userFutureData = getFutureData();
    _pageFutureData = getPageData();
    _checkLogin = checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizedBoxHeight = 15;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: Future.wait([_userFutureData, _pageFutureData]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map userData = snapshot.data[0];
          List<Pages> pages = snapshot.data[1];

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: HeadCurvedContainer(),
                child: Container(
                  height: height,
                  width: width,
                ),
              ),
              Container(
                height: height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: width / 3,
                        height: width / 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/account.png'),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${userData['first_name']} ${userData['last_name']}",
                            style: TextStyle(fontSize: 25, letterSpacing: 1.5),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: primary2,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, ProfilePage.routeName);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Container(
                        decoration: mainContainerBoxDecor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SettingsListTile(
                                title: "My Orders",
                                iconData: Icons.delivery_dining,
                                onTap: () {
                                  Navigator.pushNamed(context, OrdersPage.routeName);
                                },
                              ),
                              Divider(color: primary2),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: pages.length,
                                  itemBuilder: (context, index) {
                                    return SettingsListTile(
                                      title: pages[index].name,
                                      iconData: Icons.info_outline_rounded,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => WebViewContainer(pages[index].name, pages[index].url),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              Divider(color: primary2),
                              FutureBuilder(
                                  future: _checkLogin,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      bool isLogIn = snapshot.data;
                                      return isLogIn
                                          ? SettingsListTile(
                                              title: "Logout",
                                              iconData: Icons.logout,
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Logging out...."),
                                                        content: Text("Do you want to log out?"),
                                                        actions: [
                                                          getButton("Yes", Icons.logout, () async {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            await Provider.of<SharedPrefProvider>(context, listen: false).clearData().then((value) {
                                                              setState(() {
                                                                _userFutureData = getFutureData();

                                                                _checkLogin = checkLogin();
                                                                isLoading = false;
                                                              });
                                                              Navigator.pop(context);

                                                              if (value) {
                                                                showSimpleDialog("Logout successful", "Thank you for shopping with us!");
                                                              } else {
                                                                showSimpleDialog(
                                                                    "Something went wrong", "Please contact technical assistant or try again later");
                                                              }
                                                            });
                                                          }),
                                                          getButton("No", Icons.cancel_outlined, () {
                                                            Navigator.pop(context);
                                                          }),
                                                        ],
                                                      );
                                                    });
                                              },
                                            )
                                          : SettingsListTile(
                                              title: "Log In",
                                              iconData: Icons.login,
                                              onTap: () {},
                                            );
                                    } else {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: mainContainerBoxDecor.copyWith(color: primaryLight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Please Wait!!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 1.5, fontWeight: FontWeight.w500),
                          ),
                          CircularProgressIndicator(backgroundColor: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future getFutureData() async {
    var data = Provider.of<SharedPrefProvider>(context, listen: false).getUserData();

    return data;
  }

  Future getPageData() {
    var data = Provider.of<SharedPrefProvider>(context, listen: false).getPageData();
    return data;
  }

  Future checkLogin() {
    var data = Provider.of<SharedPrefProvider>(context, listen: false).isLoggedIn();
    return data;
  }

  showSimpleDialog(String title, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(title, textAlign: TextAlign.center),
            children: [
              Text(content, textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: getButton("Ok", Icons.thumb_up_outlined, () {
                  Navigator.pop(context);
                }),
              )
            ],
          );
        });
  }
}

/*SettingsListTile(
                                title: "Change Password",
                                iconData: Icons.lock_outline_rounded,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ChangePasswordPage.routeName);
                                },
                              ),*/
