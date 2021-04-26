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
      print(
          "## sharedPrefProvider.dart : save(String session) : error = ${e.toString()}");
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
        _pagesList.add(Pages(shr.getString('pageID$i'),
            shr.getString('pageName$i'), shr.getString('pageUrl$i')));
      }
      return _pagesList;
    } catch (e) {
      print(e.toString());
    }
  }
}

class Pages {
  final String id;
  final String name;
  final String url;

  Pages(this.id, this.name, this.url);
}
