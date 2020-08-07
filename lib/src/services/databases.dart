import 'dart:async';
import 'dart:io';

import 'package:alphadealdemo/src/models/cart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alphadealdemo/src/models/client.dart';
import 'package:sqflite/sqflite.dart';

//// fetch Group Icon data
//Future<List<Cart>> fetchProductGroup() async {
//  final url = Constant.MAIN_URL_SERVICES + 'pdt_group';
//  final response = await http.get(url);
//  return parseProductGroup(response.body);
//}
//
//List<Cart> parseProductGroup(String responseBody) {
//  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//  return parsed
//      .map<Cart>((json) => Cart.fromMap(json))
//      .toList();
//}

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "alphadealDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "XVConCode TEXT,"
          "XVUser TEXT,"
          "XVName TEXT,"
          "XVEmail TEXT"
          ")");
      await db.execute("CREATE TABLE Cart ("
          "XVBarCode TEXT,"
          "XVBarName TEXT,"
          "XVBarNameOth TEXT,"
          "XFBarRetPri1 TEXT,"
          "XIQty INTEGER"
          ")");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,XVConCode,XVUser,XVName,XVEmail)"
        " VALUES (?,?,?,?,?)",
        [
          id,
          newClient.XVConCode,
          newClient.XVUser,
          newClient.XVName,
          newClient.XVEmail
        ]);
    return raw;
  }

  newCart(Cart newCart) async {
    final db = await database;
    String barCode = newCart.XVBarCode;
    //get the biggest id in the table
    var table =
        await db.rawQuery("SELECT * FROM Cart WHERE XVBarCode = '$barCode'");
    if (table.length > 0) {
      //print(table.elementAt(0).values.last);
      int oldQty = table.elementAt(0).values.last;
      int newQty = newCart.XIQty;
      int updateQty = oldQty+newQty;
      var raw = await db.rawUpdate(
          'UPDATE Cart SET XIQty = ? WHERE XVBarCode = ?',
          [updateQty, barCode]);
      return raw;
    } else {
      var raw = await db.rawInsert(
          "INSERT Into Cart (XVBarCode,XVBarName,XVBarNameOth,XFBarRetPri1,XIQty)"
          " VALUES (?,?,?,?,?)",
          [
            barCode,
            newCart.XVBarName,
            newCart.XVBarNameOth,
            newCart.XFBarRetPri1,
            newCart.XIQty
          ]);
      return raw;
    }
  }

  editCart(Cart newCart) async {
    final db = await database;
    String barCode = newCart.XVBarCode;
    //get the biggest id in the table
    var table =
    await db.rawQuery("SELECT * FROM Cart WHERE XVBarCode = '$barCode'");
    if (table.length > 0) {
//      print(table.elementAt(0).values.last);
//      int oldQty = table.elementAt(0).values.last;
//      int newQty = newCart.XIQty;
//      int updateQty = oldQty+newQty;
      var raw = await db.rawUpdate(
          'UPDATE Cart SET XIQty = ? WHERE XVBarCode = ?',
          [newCart.XIQty, barCode]);
      return raw;
    } else {
      var raw = await db.rawInsert(
          "INSERT Into Cart (XVBarCode,XVBarName,XVBarNameOth,XFBarRetPri1,XIQty)"
              " VALUES (?,?,?,?,?)",
          [
            barCode,
            newCart.XVBarName,
            newCart.XVBarNameOth,
            newCart.XFBarRetPri1,
            newCart.XIQty
          ]);
      return raw;
    }
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  getClientId() async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [1]);
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list[0].XVConCode;
  }

  getCart(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

//  Future<List<Client>> getBlockedClients() async {
//    final db = await database;
//
//    print("works");
//    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
//    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);
//
//    List<Client> list =
//    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
//    return list;
//  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Cart>> getAllCarts() async {
    final db = await database;
    var res = await db.query("Cart");
    List<Cart> list =
        res.isNotEmpty ? res.map((c) => Cart.fromMap(c)).toList() : [];
    return list;
  }

  Future<List> getPdtCodeFromCart() async {
    final db = await database;
    var res = await db.query("Cart");
    var pdtCode = [];
    List<Cart> list =
        res.isNotEmpty ? res.map((c) => Cart.fromMap(c)).toList() : [];
    for (var row in list) pdtCode.add(row.XVBarCode);
    return pdtCode;
  }

  getCountNotiCart() async {
    final db = await database;
    var res = await db.rawQuery('SELECT SUM(XIQty) AS XIQty FROM Cart', []);
    var qty = 0;
    List<CartNoti> list =
        res.isNotEmpty ? res.map((c) => CartNoti.fromMap(c)).toList() : [];
    (list.length > 0) ? qty = list[0].XIQty : qty = 0;
    return qty;
    //print
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Client");
  }

  deleteAllCart() async {
    final db = await database;
    db.rawDelete("Delete from Cart");
  }

  deleteCart(String barCode) async {
    final db = await database;
    return db.delete("Cart", where: "XVBarCode = ?", whereArgs: [barCode]);
  }
}
