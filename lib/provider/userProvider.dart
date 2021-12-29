
import 'dart:async';

import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:angeliq_distr/models/user.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

  class UserProvider extends ChangeNotifier{
    String url = 'https://angeliquedistribution.asnumeric.com/api/auth';
    User _user;

    User getUserInfo(){
      return _user;
    }
    setUserInfo(User user){
      _user = user;
      print(_user.userName);
      notifyListeners();
  }


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
          print('No internet');
          return false;
        }
      } else {
        print(
            "Neither mobile data or WIFI detected, not internet connection found.");
        return false;
      }
    }


    Future<dynamic> login(FormData data)async{
      isInternet();
      var body = data;
      var loginStatus = {'status':false,'netWorkStatus':false};
        Dio dio = new Dio();
        await dio.post(
          url+'auth',
          data: body,
        ).then((response){
              if(response.statusCode == 200){
                if(response.data['connect']){
                  loginStatus = {'status':true,'netWorkStatus':true};
                  User user = User.fromMap(response.data);
                  user.saveUserData();
                }else{
                  loginStatus = {'status':false,'netWorkStatus':true};
                }
              }
            }
        ).catchError((error) => print(error));

      return loginStatus;
  }

  }