import 'dart:convert';

import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProvider with ChangeNotifier {
  String _session = null;
  Map userDetails = {
    'first_name': null,
    'last_name': null,
    'mobile': null,
    'email_id': null,
    'address': null,
    'state': null,
    'city': null,
    'pincode': null,
    'landmark': null,
    'contact_person': null,
    'contact_number': null,
  };
  Map shopDetails = {};

  List<Pages> _pagesList = [];
  List<Pages> get pagesList => _pagesList;

  Future<bool> isLoggedIn() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    if (shr.containsKey("session")) {
      _session = shr.getString("session");
      if (_session.isEmpty || _session == null)
        return false;
      else
        return true;
    } else
      return false;
  }

  Future<bool> save(Map userData) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.setString('session', userData['session']);
      shr.setString('first_name', userData['first_name']);
      shr.setString('last_name', userData['last_name']);
      shr.setString('mobile', userData['mobile']);
      shr.setString('email_id', userData['email_id']);

      return true;
    } catch (e) {
      print("## sharedPrefProvider.dart : save(String session) : error = ${e.toString()}");
      return false;
    }
  }

  Future<bool> clearData() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.remove("session");
      shr.remove("first_name");
      shr.remove("last_name");
      shr.remove("mobile");
      shr.remove("email_id");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map> getUserData() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    Map userData = {
      'first_name': shr.getString('first_name') ?? 'Hello,',
      'last_name': shr.getString('last_name') ?? 'User',
      'mobile': shr.getString('mobile') ?? '00000',
      'email_id': shr.getString('email_id') ?? 'email',
    };

    return userData;
  }

  Future storePageData(List pages) async {
    try {
      if (pages.length > 0) {
        SharedPreferences shr = await SharedPreferences.getInstance();
        shr.setInt("page_count", pages.length);
        for (int i = 0; i < pages.length; i++) {
          shr.setString("pageID$i", pages[i]['id']);
          shr.setString("pageName$i", pages[i]['name']);
          shr.setString("pageUrl$i", pages[i]['page_url']);
        }
        print("Page Data Stored");
        //getPageData();
//        print(pages);
      }
    } catch (e) {}
  }

  Future<List> getPageData() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      int count = shr.getInt("page_count");
      _pagesList.clear();
      for (int i = 0; i < count; i++) {
        _pagesList.add(Pages(shr.getString('pageID$i'), shr.getString('pageName$i'), shr.getString('pageUrl$i')));
      }
      return _pagesList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future storeShopData(List shop) async {
    try {
      if (shop.length > 0) {
        SharedPreferences shr = await SharedPreferences.getInstance();
        shr.setString("shopname", shop[0]['shopname']);
        shr.setString("support_mobile", shop[0]['support_mobile']);
        shr.setString("support_emailid", shop[0]['support_emailid']);
        shr.setString("op_hours", shop[0]['op_hours']);
        shr.setString("add1", shop[0]['add1']);
        shr.setString("add2", shop[0]['add2']);
        shr.setString("landmark", shop[0]['landmark']);
        shr.setString("city", shop[0]['city']);
        shr.setString("pincode", shop[0]['pincode']);
        //shr.setString("geolocation", shop[0]['geolocation']);

        print("General Shop info stored");
        //getPageData();
//        print(pages);
      }
    } catch (e) {}
  }

  Future<ShopGeneralData> getShopData() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      return ShopGeneralData(
        shopName: shr.getString('shopname'),
        supportMobile: shr.getString('support_mobile'),
        supportEmail: shr.getString('support_emailid'),
        opHours: shr.getString('op_hours'),
        add1: shr.getString('add1'),
        add2: shr.getString('add2'),
        landmark: shr.getString('landmark'),
        city: shr.getString('city'),
        pincode: shr.getString('pincode'),
      );
    } catch (e) {
      print(e.toString());
      return ShopGeneralData(
        shopName: "error",
        supportMobile: "error",
        supportEmail: "error",
        opHours: "error",
        add1: "error",
        add2: "error",
        landmark: "error",
        city: "error",
        pincode: "error",
      );
    }
  }
  //----------------------------------------------------------------

  //storing delivery related details
  Future<bool> storeDeliveryTotalAmount(double totAmt) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.setDouble("del_totAmt", totAmt);
      print("Stored delivery total amount : $totAmt");

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //this method is called from shopDataProvider.dart
  Future<bool> storeDeliveryDetails(Map data) async {
    try {
      String jsonData = json.encode(data);
      //print(jsonData);
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.setString("del_details", jsonData);
      print("Stored coupon,delivery charges, paymentmethods ");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //this method is called from timeSlot.dart
  Future<bool> storeDeliveryTimeSlot(String date, String time) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.setString("del_date", date);
      shr.setString("del_time", time);
      print("Stored delivery date : $date");
      print("Stored delivery time : $time");

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> storeDeliveryAddress(
      String cadd_id, String addr, String landmark, String city, String state, String pin, String contactPerson, String contactNo) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      shr.setString("del_cadd_id", cadd_id);
      shr.setString("del_addr", addr);
      shr.setString("del_landmark", landmark);
      shr.setString("del_city", city);
      shr.setString("del_state", state);
      shr.setString("del_pin", pin);
      shr.setString("del_contactperson", contactPerson);
      shr.setString("del_contactno", contactNo);
      print("Stored delivery address : $addr \n $city, $state, $pin, \n $contactPerson, $contactNo");

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //------------------------------------------------------------------------
  //getting delivery related details
  Future getDeliveryDetails() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();

      double amt = shr.getDouble("del_totAmt");
      Map details = json.decode(shr.getString("del_details")) as Map;
      String mobile = shr.getString("mobile");
      String session = shr.getString("session");
      String cadd_id = shr.getString("del_cadd_id");
      String address = shr.getString("del_addr");
      String landmark = shr.getString("del_landmark");
      String city = shr.getString("del_city");
      String state = shr.getString("del_state");
      String pincode = shr.getString("del_pin");
      String contactperson = shr.getString("del_contactperson");
      String contactno = shr.getString("del_contactno");
      String bookDate = shr.getString("del_date");
      String timing = shr.getString("del_time");

      CartDataProvider cdp = CartDataProvider.instance;
      String products = await cdp.getFormattedProductsMap();
      //mobile, session, c_add, address, landmark, city, state, pincode, contactperson, contactno,
      //couponcode,
      //payment_type, specialinstruction,
      //products, book_date, timing
      Map map = {
        'total_amount': amt,
        'details': details,
        'mobile': mobile,
        'session': session,
        'cadd_id': cadd_id,
        'address': address,
        'landmark': landmark,
        'city': city,
        'state': state,
        'pincode': pincode,
        'contactperson': contactperson,
        'contactno': contactno,
        'bookDate': bookDate,
        'timing': timing,
        'products': products
      };
      //print(shr.getString('del_details'));
      print(map);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
      //return 0.0;
    }
  }
}

class Pages {
  final String id;
  final String name;
  final String url;

  Pages(this.id, this.name, this.url);
}

class ShopGeneralData {
  final String shopName;
  final String supportMobile;
  final String supportEmail;
  final String opHours;
  final String add1;
  final String add2;
  final String landmark;
  final String city;
  final String pincode;

  ShopGeneralData({
    this.shopName,
    this.supportMobile,
    this.supportEmail,
    this.opHours,
    this.add1,
    this.add2,
    this.landmark,
    this.city,
    this.pincode,
  });
}
