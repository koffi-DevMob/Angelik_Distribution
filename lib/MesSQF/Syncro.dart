import 'package:angeliq_distr/MesSQF/TableModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'BaseDonnees.dart';
import 'package:http/http.dart' as http;

class SyncronizationData {

  var mUrl = Uri.parse('https://angeliquedistribution.asnumeric.com/api/sells');

  static Future<bool> isInternet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    }else {
      print("Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ItemModel>> fetchAllInfo()async{
    final dbClient = await conn.db;
    List<ItemModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.TableItem);
      for (var item in maps) {
        contactList.add(ItemModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysqlWith(List<ItemModel> contactList)async{
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "id":contactList[i].id.toString(),
        "id_b6":contactList[i].id_b6.toString(),
        "id_b12":contactList[i].id_b12.toString(),
        "Qtiteb6":contactList[i].Qtiteb6.toString(),
        "Qtiteb12":contactList[i].Qtiteb12.toString(),
        "amount":contactList[i].amount.toString(),
        "user_id":contactList[i].user_id.toString(),
        "contact_id":contactList[i].contact_id.toString(),
        "final_total":contactList[i].final_total.toString(),
      };
      final response = await http.post(mUrl,body: data);
      if (response.statusCode==200) {
        print("Saving Data ");
      }else{
        print(response.statusCode);
      }
    }
  }

  Future<List> fetchAllCustomersInfo()async{
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.TableItem);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysql(List contactList)async{
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "id":contactList[i].id.toString(),
        "id_b6":contactList[i].id_b6.toString(),
        "id_b12":contactList[i].id_b12.toString(),
        "Qtiteb6":contactList[i].Qtiteb6.toString(),
        "Qtiteb12":contactList[i].Qtiteb12.toString(),
        "amount":contactList[i].amount.toString(),
        "user_id":contactList[i].user_id.toString(),
        "contact_id":contactList[i].contact_id.toString(),
        "final_total":contactList[i].final_total.toString(),
      };
      final response = await http.post(mUrl,body: data);
      if (response.statusCode==200) {
        print("Saving Data ");
      }else{
        print(response.statusCode);
      }
    }
  }

}