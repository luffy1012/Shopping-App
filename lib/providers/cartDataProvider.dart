import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDataProvider with ChangeNotifier {
  static final _dbName = "test1.db";
  static final _dbVersion = 1;

  static final _tableName = "myTable";
  static final _colProductId = "product_id";
  static final _colPid = "pid";

  static final _colProductName = "product_name";
  static final _colPrice = "product_price";
  static final _colQty = "qty";
  static final _colQtyRes = "qty_res";
  static final _colImgUrl = "img_url";

  static get colProductId => _colProductId;

  static get colPid => _colPid;

  static get colProductName => _colProductName;

  static get colPrice => _colPrice;

  static get colQty => _colQty;

  static get colQtyRes => _colQtyRes;

  static get colImgUrl => _colImgUrl;

  static get dbName => _dbName;

  //singleton class
  CartDataProvider._privateConstructor();

  static final CartDataProvider instance = CartDataProvider._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) {
    try {
      String query = '''
    CREATE TABLE $_tableName(
      $_colPid Text NOT NULL,
      $_colProductId TEXT PRIMARY KEY,
      $_colProductName TEXT NOT NULL,
      $_colPrice REAL NOT NULL,
      $_colQty INTEGER NOT NULL,
      $_colQtyRes INTEGER NOT NULL,
      $_colImgUrl TEXT NOT NULL
    )
    ''';
      db.execute(query);
      print("TABLE CREATED");
    } catch (e) {
      print("ERROR ONCREATE : ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getRowByID(String productID) async {
    Database db = await instance.database;
    var data = await db.query(_tableName, where: '$_colProductId=?', whereArgs: [productID]);
    return data;
  }

  Future insertProduct(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      print("Insert");
      var data = await db.insert(_tableName, row);
      print("INSERTED $data");
      return data;
    } catch (e) {
      print("MESSAGE : ${e.toString()}");
    }
  }

  Future<int> getNumberOfProducts() async {
    try {
      Database db = await instance.database;
      var data = await db.rawQuery("SELECT COUNT (*) FROM $_tableName");
      int count = Sqflite.firstIntValue(data);

      return count;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<int> updateCart(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      var i = await db.update(_tableName, row, where: '$_colProductId = ?', whereArgs: [row['$_colProductId']]);
      return i;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      Database db = await instance.database;
      var data = await db.query(_tableName);
      return data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future removeProduct(String productID) async {
    try {
      Database db = await instance.database;
      var res = db.delete(_tableName, where: '$_colProductId = ?', whereArgs: [productID]);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List> isProductExist(String productID) async {
    var result;
    try {
      // Database db = await instance.database;
      result = await getRowByID(productID);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int> truncateTable() async {
    try {
      Database db = await instance.database;
      int result = await db.delete(_tableName);
      return result;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<String> getFormattedProductsMap() async {
    try {
      Database db = await instance.database;
      //Map map = {};
      //Map product = {};
      var data = await db.rawQuery("select $_colPid, $_colQty, $_colPrice from $_tableName");
      // print(data.runtimeType);
      // print(data);
      var jsonEncodeData = json.encode(data);
      // String jsonData=json.decode(jsonEncodeData);
      //print(jsonEncodeData);
      return jsonEncodeData;
    } catch (e) {
      print(e);
    }
  }
}
/*pid TEXT--
name TEXT
price REAL--
qty INTEGER--
qty_res INTEGER
img TEXT*/

/*
  Future<Map> getAllProductsIdQty() async {
    Map<String, dynamic> map = {};
    try {
      var data = await getAllProducts();
      // print(data.runtimeType);
      // print(data);
      data.forEach((element) {
        map[element[_colProductId]] = {_colQty: element[_colQty], _colQtyRes: element[_colQtyRes]};
      });
      print(map);
      //  return map;
    } catch (e) {
      print(e.toString());
      return map;
    }
  }
*/
/*
[
  {
    "id": "f0f79613-90a5-11eb-8412-ee500252f38c",
    "qty": "2",
    "price": "21.0"
  },
  {
    "id": "f0f792f1-90a5-11eb-8412-ee500252f38c",
    "qty": "1",
    "price": "21.0"
  }
]
*/
