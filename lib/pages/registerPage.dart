import 'dart:ui';

import 'package:chef_choice/pages/loginPage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/MyClipper.dart';
import 'package:chef_choice/uiResources/PageConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';

class RegisterPage extends StatefulWidget {
  static final String routeName = "/regPage";

  final String mobileNo;
  final int goToPage;
  RegisterPage({@required this.mobileNo, @required this.goToPage});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  GlobalKey<FormState> _key2 = GlobalKey<FormState>();

  PageController _pageController = PageController(initialPage: 0);

  List<String> states = ['Maharashtra', 'goa'];
  String _selectedState;

  bool isLoading = false;
  TextEditingController _tecFName, _tecLName, _tecMobile, _tecEmail, _tecContactPerson, _tecContactNum;
  TextEditingController _tecAddr, _tecLandMark, _tecCity, _tecState, _tecPincode;
  TextEditingController _tecOtp;

  @override
  void initState() {
    // TODO: implement initState
    loadStates();
    super.initState();
    _tecFName = TextEditingController();
    _tecLName = TextEditingController();
    _tecMobile = TextEditingController(text: widget.mobileNo);
    _tecEmail = TextEditingController();
    _tecContactPerson = TextEditingController();
    _tecContactNum = TextEditingController(text: widget.mobileNo);

    _tecAddr = TextEditingController();
    _tecLandMark = TextEditingController();
    _tecCity = TextEditingController();
    _tecState = TextEditingController();
    _tecPincode = TextEditingController();
    _tecOtp = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double sizedBoxHeight = 10;
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
                height: height / 1.1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight, end: Alignment.topLeft, colors: [primary2, primaryLight, primaryLight.withOpacity(0.7)])),
              ),
            ),
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Form(
                  key: _key1,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                                BoxShadow(
                                  color: primary2.withOpacity(0.35),
                                  blurRadius: 8.0,
                                  offset: Offset(3, 3),
                                ),
                              ]),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  children: [
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: false,
                                      controller: _tecMobile,
                                      keyboardType: TextInputType.phone,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.phone, color: primary2),
                                        hintText: "Enter your mobile number",
                                        labelText: "Mobile Number",
                                      ),
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecOtp,
                                      keyboardType: TextInputType.number,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.lock_clock, color: primary2),
                                        hintText: "Enter your OTP",
                                        labelText: "OTP",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
//--------------------------------
                                    SizedBox(height: 5),
                                    Divider(thickness: 1, color: primary2),
                                    SizedBox(height: 5),
//--------------------------------
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _tecContactPerson.text = "$value ${_tecLName.text}";
                                        });
                                      },
                                      enabled: !isLoading,
                                      controller: _tecFName,
                                      keyboardType: TextInputType.name,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.account_circle_outlined, color: primary2),
                                        hintText: "Enter your first name",
                                        labelText: "First Name",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _tecContactPerson.text = "${_tecFName.text} $value";
                                        });
                                      },
                                      enabled: !isLoading,
                                      controller: _tecLName,
                                      keyboardType: TextInputType.name,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.account_circle_outlined, color: primary2),
                                        hintText: "Enter your last name",
                                        labelText: "Last Name",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.alternate_email_outlined, color: primary2),
                                        hintText: "Enter your email",
                                        labelText: "Email",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else if (!RegExp("[^@]+@[^\.]+\..+").hasMatch(value))
                                          return "Invalid Email";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        getButton(
                                          "Fill Address Details",
                                          Icons.keyboard_arrow_right_outlined,
                                          () async {
                                            if (_key1.currentState.validate()) {
                                              _pageController.animateToPage(1,
                                                  curve: Curves.easeInOutQuart,
                                                  duration: Duration(milliseconds: 1500)); // for animated jump. Requires a curve and a duration

                                            }
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
                  ),
                ),
                Form(
                  key: _key2,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                                BoxShadow(
                                  color: primary2.withOpacity(0.35),
                                  blurRadius: 8.0,
                                  offset: Offset(3, 3),
                                ),
                              ]),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecContactPerson,
                                      keyboardType: TextInputType.name,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.people_outline, color: primary2),
                                        hintText: "Contact person",
                                        labelText: "Contact Person",
                                      ),
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecContactNum,
                                      keyboardType: TextInputType.phone,
                                      decoration: textfield1Deco.copyWith(
                                          prefixIcon: Icon(Icons.phone, color: primary2),
                                          hintText: "Contact number",
                                          labelText: "Contact Number",
                                          counterText: ""),
                                      maxLength: 10,
                                    ),
//--------------------------------
                                    SizedBox(height: 5),
                                    Divider(thickness: 1, color: primary2),
                                    SizedBox(height: 5),
//--------------------------------
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecAddr,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.home_outlined, color: primary2),
                                        hintText: "Enter your address",
                                        labelText: "Address",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecLandMark,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.landscape_outlined, color: primary2),
                                        hintText: "Enter landmark",
                                        labelText: "Landmark",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecCity,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.location_city_outlined, color: primary2),
                                        hintText: "Enter your city",
                                        labelText: "City",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),

                                    Listener(
                                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                                      child: DropdownButtonFormField<String>(
                                        icon: Icon(Icons.arrow_drop_down_outlined, color: primary2),
                                        decoration: textfield1Deco.copyWith(prefixIcon: Icon(Icons.location_on_outlined, color: primary2)),
                                        validator: (value) {
                                          if (value == null)
                                            return "Please select a state";
                                          else
                                            return null;
                                        },
                                        isExpanded: true,
                                        value: _selectedState,
                                        hint: Text("Select State"),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedState = value;
                                          });
                                        },
                                        items: states
                                            .map(
                                              (e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),

/*
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecState,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: textfield1Deco.copyWith(
                                        prefixIcon: Icon(Icons.location_on_outlined, color: primary2),
                                        hintText: "Enter your state",
                                        labelText: "State",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else
                                          return null;
                                      },
                                    ),
*/

                                    SizedBox(height: sizedBoxHeight),
                                    TextFormField(
                                      enabled: !isLoading,
                                      controller: _tecPincode,
                                      keyboardType: TextInputType.number,
                                      decoration: textfield1Deco.copyWith(
                                          prefixIcon: Icon(Icons.location_on_outlined, color: primary2),
                                          hintText: "Enter your pincode",
                                          labelText: "Pincode",
                                          counterText: ""),
                                      maxLength: 6,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field cannot be empty";
                                        else if (value.length < 6)
                                          return "Pincode must be of 6 digits";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: sizedBoxHeight),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        getButton("Go back", Icons.keyboard_arrow_left_outlined, () {
                                          _pageController.animateToPage(
                                            0,
                                            curve: Curves.easeInOutQuart,
                                            duration: Duration(milliseconds: 1500),
                                          );
                                        }),
                                        getButton(
                                          "Register",
                                          Icons.person_add,
                                          () async {
                                            if (_key2.currentState.validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await Provider.of<ShopDataProvider>(context, listen: false)
                                                  .registerCustomer(
                                                      _tecFName.text,
                                                      _tecLName.text,
                                                      _tecMobile.text,
                                                      _tecEmail.text,
                                                      _tecContactPerson.text,
                                                      _tecContactNum.text,
                                                      _tecAddr.text,
                                                      _tecLandMark.text,
                                                      _tecCity.text,
                                                      _selectedState,
                                                      _tecPincode.text,
                                                      _tecOtp.text)
                                                  .then((userData) async {
                                                //=====================================
                                                await Provider.of<SharedPrefProvider>(context, listen: false).save(userData).then((value) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  if (value) {
                                                    if (widget.goToPage == PageConstant.TimSlotPage)
                                                      Navigator.pushNamed(context, TimeSlotPage.routeName);
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
                                                //=====================================
                                              }).catchError((e) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Something went wrong!"),
                                                      content: Text(e.toString()),
                                                    );
                                                  },
                                                );
                                              });
                                            }
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
                  ),
                ),
              ],
            ),
            if (isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: mainContainerBoxDecor.copyWith(color: primary2),
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
        ),
      ),
    );
  }

  Future<void> loadStates() async {
    List<String> data = await Provider.of<ShopDataProvider>(context, listen: false).getStatesList();
    setState(() {
      states = List<String>.from(data);
    });
  }
}
