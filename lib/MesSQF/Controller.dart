import 'package:angeliq_distr/MesSQF/ModelClient.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


import 'BaseDonnees.dart';
import 'TableModel.dart';


class Controller {
  final conn = SqfliteDatabaseHelper.instance;


  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  Future<int> addClient(ClientModel clientinfoModel) async {
    var dbclients = await conn.db;
    int result;
    try {
      result = await dbclients.insert(
          SqfliteDatabaseHelper.TableClient, clientinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }


  Future fetchAllClient() async {
    var dbclient = await conn.db;
    List clientList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient.query(
          SqfliteDatabaseHelper.TableClient, orderBy: 'id ASC');
      for (var item in maps) {
        clientList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return clientList;
  }


  Future<int> addData(ItemModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.TableItem, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }


  Future<int> updateData(ItemModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.TableItem, contactinfoModel.toJson(),
          where: 'id=?', whereArgs: [contactinfoModel.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchData() async {
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient.query(
          SqfliteDatabaseHelper.TableItem, orderBy: 'id DESC');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }



}