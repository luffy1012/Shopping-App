import 'dart:convert';

import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDataProvider with ChangeNotifier {
  final shopID = 1;
  final apiKey = "KPsKeutBQVGJuXPHT5uE7Nng7Nz28tGGy853vBV6urUGg7FWEa";

  List<Category> _categories = [];
  List<Area> _areas = [];
  List<ProductList> _productLists = [];
  List<ProductList> _featuredProductLists = [];
  List<ProductList> _bannerProductLists = [];

  List<String> _stateList = [];

  List<MyBanner> _banners = [];
  Product _product;
  List _productImgList = [];

  List<Category> get categories => _categories;
  List<Area> get areas => _areas;
  List<ProductList> get productLists => _productLists;
  Product get product => _product;
  List get productImgList => _productImgList;

  Future<bool> checkPincode(String pincode) async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/pincheck?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'pincode': pincode});
      final jsonRes = json.decode(response.body) as Map;
      if (response.statusCode == 200) {
        if (jsonRes['status'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        throw "Server Response code : ${response.statusCode}";
      }
    } catch (e) {
      print("## shopDataProvider.dart : getCategories() : ${e.toString()}");
    }
  }

  Future<List<ProductList>> getProductsByCategory(String categoryId) async {
    try {
      final url = "https://my.umart.in/Api/products/category/$categoryId?shopID=$shopID&key=$apiKey&order=asc-title";
      final response = await http.get(Uri.parse(url));
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        final productsData = jsonRes['data'];
        _productLists.clear();
        productsData.forEach((element) {
          _productLists.add(ProductList(element['product_id'], element['p_uid'], element['title'], element['price'], element['product_image']));
        });
        return _productLists;
      } else {
        print("##11 shopDataProvider.dart : getProductsByCategory(String category_id) : ${jsonRes['message']}");
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getProductsByCategory(String category_id) : ${e.toString()}");
      return [ProductList("error", "error", "error", "error", "error")];
    }
  }

  Future<List<ProductList>> getProductsBySearch(String keyword) async {
    try {
      final url = "https://my.umart.in/Api/products/search/?shopID=$shopID&key=$apiKey&order=asc-title&keyword=$keyword";
      final response = await http.get(Uri.parse(url));
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        final productsData = jsonRes['data'];
        _productLists.clear();
        productsData.forEach((element) {
          _productLists.add(ProductList(element['product_id'], element['p_uid'], element['title'], element['price'], element['product_image']));
        });
        return _productLists;
      } else {
        print("##11 shopDataProvider.dart : getProductsBySearch(String keyword) : ${jsonRes['message']}");
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getProductsBySearch(String keyword) : ${e.toString()}");
      return [ProductList("error", "error", "error", "error", "error")];
    }
  }

  Future<List<ProductList>> getMultipleProductsById(List<String> ids) async {
    try {
      var url;
      var response;
      var jsonRes;
      _productLists.clear();
      for (int i = 0; i < ids.length; i++) {
        url = "https://my.umart.in/Api/products/detailsbyuid/${ids[i]}?shopID=$shopID&key=$apiKey";
        response = await http.get(Uri.parse(url));
        jsonRes = json.decode(response.body) as Map;

        _productLists.add(ProductList(jsonRes['product_id'], ids[i], jsonRes['title'], jsonRes['price'], jsonRes['product_image']));
      }
      return _productLists;
    } catch (e) {
      print("## shopDataProvider.dart : getMultipleProductsById(List<String> ids) : ${e.toString()}");
      return [ProductList("error", "error", "error", "error", "error")];
    }
  }

  Future<Product> getProductDetails(String productId) async {
    try {
      final url = "https://my.umart.in/Api/products/detailsbyuid/$productId?shopID=$shopID&key=$apiKey";
      final response = await http.get(Uri.parse(url));
      final jsonRes = json.decode(response.body) as Map;
      if (response.statusCode == 200 && jsonRes.containsKey('title')) {
        _productImgList.clear();

        jsonRes['gallery'].forEach((element) {
          _productImgList.add(element['filename']);
        });
        _product = Product(jsonRes['product_id'], productId, jsonRes['title'], jsonRes['description'], jsonRes['price'], jsonRes['old_price'],
            int.parse(jsonRes['qty_res']), jsonRes['catname'], _productImgList);
        return _product;
      } else {
        print("## shopDataProvider.dart : getProductDetails(String product_id) : ${jsonRes['message']}");
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getProductDetails(String product_id) : ${e.toString()}");
      return Product("", "error", "error", "error", "error", "error", 0, "error", ["error"]);
    }
  }

  Future getBannerOnTapData(String banType, String id) async {
    try {
      var url = "https://my.umart.in/Api/products/";
      if (banType == "category") {
        url += "categorydetails/?shopID=$shopID&key=$apiKey";
      } else if (banType == "product") {
        url += "productsdetails/?shopID=$shopID&key=$apiKey";
      } else if (banType == "banner") {
        url += "bannerdetails/?shopID=$shopID&key=$apiKey";
      } else {
        throw "No implementation for this ban_type";
      }

      final response = await http.post(Uri.parse(url), body: {'id': id});
      if (response.statusCode == 200) {
        if (banType == "category" || banType == "product") {
          final jsonRes = json.decode(response.body) as Map;
          var data = jsonRes["data"];
          _bannerProductLists.clear();
          data.forEach((element) {
            _bannerProductLists
                .add(ProductList(element['product_id'], element['p_uid'], element['title'], element['price'], element['product_image']));
          });
          return _bannerProductLists;
        } else {
          //if banner type is banner
          //TODO implement this, i didn't understand it's purpose
          return response.body;
        }
      } else {
        throw "Status Code : ${response.statusCode}";
      }
    } catch (e) {
      print("## shopDataProvider.dart : getBannerOnTapData(String banType, String id) : ${e.toString()}");
    }
  }

  Future<Map> getShopDetails() async {
    try {
      if (_categories.length == 0 && _bannerProductLists.length == 0 && _featuredProductLists.length == 0) {
        final url = 'https://my.umart.in/Api/shopinfo/all/?shopID=$shopID&key=$apiKey';
        final response = await http.get(Uri.parse(url));
        final jsonRes = json.decode(response.body) as Map;

        if (jsonRes['status'] == 'failed' || jsonRes['status'] == 'false') {
          print("## shopDataProvider.dart : getShopDetails() : ${jsonRes['message']}");
          throw (jsonRes['message']);
        } else {
          //TODO get all data for Home Tab
          // print("Store page data");
          var pages = jsonRes['data']['pages'];
          await SharedPrefProvider().storePageData(pages);

          var shopDetails = jsonRes['data']['general'];
          await SharedPrefProvider().storeShopData(shopDetails);

          // print("Pages stored");
          // print("Not again!");
          try {
            _categories.clear();
            final categoryList = jsonRes['data']['category'];
            categoryList.forEach((element) {
              _categories.add(Category(element['id'], element['name'], element['abbr'], element['cat_url'], element['c_uid'], element['cat_image']));
            });
          } catch (e) {
            print("## shopDataProvider.dart : getShopDetails() : ${e.toString()}");
            _categories.add(Category("error", "error", "error", "error", "error", "error"));
          }

          final productsData = jsonRes['data']['products'];
          _featuredProductLists.clear();
          productsData.forEach((element) {
            _featuredProductLists
                .add(ProductList(element['product_id'], element['p_uid'], element['title'], element['price'], element['product_image']));
          });

          final bannerData = jsonRes['data']['banner'];
          _banners.clear();
          bannerData.forEach((element) {
            _banners.add(
                MyBanner(element['id'], element['ban_type'], element['banner_title'], element['banner_image'], element['link'], element['details']));
          });
        }
      }

      Map<String, dynamic> data = {'categories': _categories, 'featuredProducts': _featuredProductLists, 'banners': _banners};
      //print(data);

      return data;
    } catch (e) {
      print("## shopDataProvider.dart : getShopDetails() : ${e.toString()}");
      Map<String, dynamic> data = {
        'categories': [Category("error", "error", "error", "error", "error", "error")],
        'featuredProducts': [ProductList("error", "error", "error" "error", "error", "error")],
        'banners': [MyBanner("error", "error", "error", "error", "error", "error")]
      };
      return data;
    }
  }

  Future<bool> checkMobile(String mobileNo) async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/mobilecheck?shopID=$shopID&key=$apiKey";
      var response = await http.post(Uri.parse(url), body: {'mobile': mobileNo});
      var jsonRes = json.decode(response.body) as Map;
      if (response.body.isNotEmpty) {
        if (jsonRes['login'] == true && jsonRes['registration'] == false)
          return true;
        else if (jsonRes['login'] == false && jsonRes['registration'] == true)
          return false;
        else
          throw "Conflicting status of login(${jsonRes['login']}) and registration(${jsonRes['registration']})";
      } else {
        throw "Status from api ${jsonRes['status']}";
      }
    } catch (e) {
      print("## shopDataProvider.dart : checkMobile(String mobileNo) : ${e.toString()}");
      return Future.error(e.toString());
    }
  }

  Future<Map> checkOTP(String mobileNo, String otp) async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/login?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'mobile': mobileNo, 'otp': otp});
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status']) {
        final userData = jsonRes['data'] as Map;
        Map userDetails = {
          'session': jsonRes['session'],
          'first_name': userData.containsKey("name") ? userData['name'].toString().split(" ")[0] : "User",
          'last_name': userData.containsKey("name") ? userData['name'].toString().split(" ")[1] : "User",
          'mobile': userData.containsKey("mobile") ? userData["mobile"] : "0",
          'email_id': userData.containsKey("emailid") ? userData["emailid"] : "email",
        };
        return userDetails;
      } else
        throw jsonRes['message'];
    } catch (e) {
      print("## shopDataProvider.dart : checkOTP(String mobileNo, String otp) : ${e.toString()}");
      return Future.error(e.toString());
    }
  }

  Future<Map> registerCustomer(String fName, String lName, String mobile, String email, String famName, String famContact, String addr,
      String landmark, String city, String state, String pincode, String otp) async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/registration?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {
        'first_name': fName,
        'last_name': lName,
        'mobile': mobile,
        'emailid': email,
        'contactperson': famName,
        'contactno': famContact,
        'address': addr,
        'landmark': landmark,
        'city': city,
        'state': state,
        'pincode': pincode,
        'otp': otp
      });

      final jsonRes = json.decode(response.body) as Map;

      if (jsonRes['status']) {
        final userData = jsonRes['data'] as Map;
        Map userDetails = {
          'session': jsonRes['session'],
          'first_name': userData.containsKey("name") ? userData['name'].toString().split(" ")[0] : "User",
          'last_name': userData.containsKey("name") ? userData['name'].toString().split(" ")[1] : "User",
          'mobile': userData.containsKey("mobile") ? userData["mobile"] : "0",
          'email_id': userData.containsKey("emailid") ? userData["emailid"] : "email",
        };
        return userDetails;
      } else
        throw jsonRes['message'];
    } catch (e) {
      print("## shopDataProvider.dart : registerCustomer() : ${e.toString()}");
      return Future.error(e.toString());
    }
  }

  Future<List<String>> getStatesList() async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/statelist/?shopID=$shopID&key=$apiKey";
      final response = await http.get(Uri.parse(url));
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        var data = jsonRes['data'];
        _stateList.clear();
        data.forEach((state) {
          _stateList.add(state['statename']);
        });
        //print(_stateList);
        return _stateList;
      } else {
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getStatesList() : ${e.toString()}");
      _stateList.clear();
      _stateList.add("Maharashtra");
      return _stateList;
    }
  }

  //---------------------------------------------------------------------------------------
  //All methods from here is used to process and place orders!
  Future getDeliveryDetails(String date, String products) async {
    try {
      print("date in method $date");
      //print(products);
      final url = "https://my.umart.in/Api/actioninfo/delivery/?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'date': date, 'products': products});
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        print(jsonRes['data'].runtimeType);

        SharedPrefProvider spf = SharedPrefProvider();
        bool isStored = await spf.storeDeliveryDetails(jsonRes['data']);
        if (isStored)
          return jsonRes;
        else
          throw "Delivery related data not stored. (ShopDataProvider.dart #339)";
      } else {
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getSchedule(String date, String products) : ${e.toString()}");
    }
  }

  Future<List> getAddressList() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      String session = shr.getString("session");
      String mobile = shr.getString("mobile");

      // print(session);
      // print(mobile);
      final url = "https://my.umart.in/Api/actioninfo/addresslist?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'mobile': mobile, 'session': session});
      final jsonRes = json.decode(response.body) as Map;
      //print(jsonRes);
      if (jsonRes['status'] == true) {
        return jsonRes['data'];
      } else {
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : getAddressList() : ${e.toString()}");
      return [];
    }
  }

  Future<String> addNewAddress(
      String address, String landmark, String city, String state, String pincode, String contactperson, String contactno) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      String session = shr.getString("session");
      String mobile = shr.getString("mobile");

      final url = "https://my.umart.in/Api/actioninfo/addressadd?shopID=$shopID&key=$apiKey";
      final response = await http.post(
        Uri.parse(url),
        body: {
          'mobile': mobile,
          'session': session,
          'address': address,
          'landmark': landmark,
          'city': city,
          'state': state,
          'pincode': pincode,
          'contactperson': contactperson,
          'contactno': contactno
        },
      );
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        return "${jsonRes['data']['id']}";
      } else {
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : addNewAddress() : ${e.toString()}");
      return null;
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      String session = shr.getString("session");
      String mobile = shr.getString("mobile");
      final url = "https://my.umart.in/Api/actioninfo/addressdel?shopID=$shopID&key=$apiKey";
      final response = await http.post(
        Uri.parse(url),
        body: {'id': id, 'mobile': mobile, 'session': session},
      );
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true)
        return true;
      else
        throw jsonRes['message'];
    } catch (e) {
      print("## shopDataProvider.dart : deleteAddress(String id) : ${e.toString()}");
      return false;
    }
  }

  Future<Map> placeOrder({
    @required String mobile,
    @required String session,
    @required String cadd_id,
    @required String address,
    @required String landmark,
    @required String city,
    @required String state,
    @required String pincode,
    @required String contactperson,
    @required String cotanctno,
    @required String couponcode,
    @required String payment_type,
    @required String specialinstruction,
    @required String products,
    @required String book_date,
    @required String timing,
  }) async {
    try {
      final url = "https://my.umart.in/Api/actioninfo/orderpost?shopID=$shopID&key=$apiKey";
      final response = await http.post(
        Uri.parse(url),
        body: {
          'mobile': mobile,
          'session': session,
          'cadd_id': cadd_id,
          'address': address,
          'landmark': landmark,
          'city': city,
          'state': state,
          'pincode': pincode,
          'contactperson': contactperson,
          'contactno': cotanctno,
          'couponcode': couponcode,
          'payment_type': payment_type,
          'specialinstruction': specialinstruction,
          'products': products,
          'book_date': book_date,
          'timing': timing,
        },
      );
      final jsonRes = await json.decode(response.body) as Map;
      print(payment_type);
      if (jsonRes['status'] == true) {
        return jsonRes;
      } else {
        throw jsonRes['message'];
      }
    } catch (e) {
      print("## shopDataProvider.dart : placeOrder() : ${e.toString()}");
      return {"status": false, "message": e.toString()};
    }
  }

  Future getOrderList() async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      String mobile = shr.getString("mobile");
      String session = shr.getString("session");

      final url = "https://my.umart.in/Api/actioninfo/orderlist?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'mobile': mobile, 'session': session});
      final jsonRes = json.decode(response.body) as Map;
      //print(jsonRes);
      if (jsonRes['status'])
        return jsonRes;
      else
        throw jsonRes['message'];
    } catch (e) {
      print("## shopDataProvider.dart : getOrderList() : ${e.toString()}");
      return e.toString();
    }
  }

  Future getOrderDetails(String oid) async {
    try {
      SharedPreferences shr = await SharedPreferences.getInstance();
      String mobile = shr.getString("mobile");
      String session = shr.getString("session");

      final url = "https://my.umart.in/Api/actioninfo/orderdetails?shopID=$shopID&key=$apiKey";
      final response = await http.post(Uri.parse(url), body: {'mobile': mobile, 'session': session, 'orderid': oid});

      final jsonRes = json.decode(response.body) as Map;

      if (jsonRes['status'])
        return jsonRes;
      else
        throw jsonRes['message'];
    } catch (e) {
      print("## shopDataProvider.dart : getOrderDetails(String oid) : ${e.toString()}");
      return e.toString();
    }
  }
}

class Category {
  final String id;
  final String name;
  final String abbrv;
  final String cat_url;
  final String c_uid;
  final cat_img;
  Category(this.id, this.name, this.abbrv, this.cat_url, this.c_uid, this.cat_img);
}

class Area {
  final int area_id;
  final String area_name;
  final int pincode;

  Area(this.area_id, this.area_name, this.pincode);
}

//Use this class when you receive list of products from API, like products by category or by search
class ProductList {
  final p_id;
  final String product_id;
  final String product_title;
  final String product_price;
  final String product_img_url;
  ProductList(this.p_id, this.product_id, this.product_title, this.product_price, this.product_img_url);
}

class Product {
  final p_id;

  final String product_id;
  final String title;
  final String desc;
  final String price;
  final String oldPrice;
  final int qty_res;
  final String category;
  final List imgUrls;

  Product(this.p_id, this.product_id, this.title, this.desc, this.price, this.oldPrice, this.qty_res, this.category, this.imgUrls);
}

class MyBanner {
  final String ban_id;
  final String ban_type;
  final String ban_title;
  final String ban_img;
  final String ban_link;
  final String ban_details;

  MyBanner(this.ban_id, this.ban_type, this.ban_title, this.ban_img, this.ban_link, this.ban_details);
}

/*
  Future<List<ProductList>> getFeaturedProducts() async {
    try {
      final url =
          "https://my.umart.in/Api/products/featured/?shopID=$shopID&key=$apiKey&order=asc-title";
      final response = await http.get(Uri.parse(url));
      final jsonRes = json.decode(response.body) as Map;
      if (jsonRes['status'] == true) {
        final productsData = jsonRes['data'];
        _featuredProductLists.clear();
        productsData.forEach((element) {
          _featuredProductLists.add(ProductList(element['p_uid'],
              element['title'], element['price'], element['product_image']));
        });
        return _featuredProductLists;
      } else {
        print(
            "##11 shopDataProvider.dart : getFeaturedProducts() : ${jsonRes['message']}");
        throw jsonRes['message'];
      }
    } catch (e) {
      print(
          "## shopDataProvider.dart : getFeaturedProducts() : ${e.toString()}");
      return [ProductList("error", "error", "error", "error")];
    }
  }
*/
/*Future<List<Category>> getCategories() async {
    try {
      if (_categories.length == 0) {
        _categories.clear();
        Map shopDetails = await getShopDetails();
        final categoryList = shopDetails['data']['category'];
        categoryList.forEach((element) {
          _categories.add(Category(
              element['id'],
              element['name'],
              element['abbr'],
              element['cat_url'],
              element['c_uid'],
              element['cat_image']));
        });
        //  print(_categories);
        return _categories;
      } else
        return _categories;
    } catch (e) {
      print("## shopDataProvider.dart : getCategories() : ${e.toString()}");
    }
    return null;
  }*/
