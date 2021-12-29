import 'dart:async';

import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/screens/home/drawer-items/NoNetMission.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ListVentes extends StatefulWidget {


  @override
  _ListVentesState createState() => _ListVentesState();
}

class _ListVentesState extends State<ListVentes> {
  Future<dynamic> getElementsVente() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int locationId = sharedPreferences.getInt(
        'businessId');
    var urlvente = 'https://angeliquedistribution.asnumeric.com/api/sells?location_id=$locationId';
    var resultvente;
    Dio dio = new Dio();
    await dio.get(urlvente).then((response) {
      if (response.statusCode == 200) {
        resultvente = response.data;
      }
    }).catchError(
            (error) => showMyDialog(msg: 'Veuillez verifier votre connexion !'));
    return resultvente;
  }

  var dte = DateTime.now().month;

  Timer _timer;

  Future isNet()async{
    await SyncronizationData.isInternet().then((connection){
      if (connection) {

        print("Internet disponible");
      }else{

        Navigator.pushReplacementNamed(context, '/pas_net_mission');
        showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
      }
    });
  }

  void initState() {

    //userList();
    isNet();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<dynamic>(
          future: getElementsVente(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingProgress();
            } else {
              List<dynamic> customers = snapshot.data;
              List<String> vente = [];
              customers?.map((data) => vente)?.toList()??[];
              print(snapshot.data);
              return Container(
                child: GestureDetector(
                  child: SingleChildScrollView(
                      child:
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          Text('Liste du mois',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:bgColor ),),
                          SizedBox(height: 20,),
                          DataTable(
                              columns: [
                                DataColumn(label: Text('Date', style: style())),
                                DataColumn(label: Text('Client', style: style())),
                                DataColumn(label: Text('Montant', style: style())),
                              ],
                              rows:
                              customers?.map((vente) =>
                                  DataRow(
                                      cells: [
                                        DataCell(
                                            Text("${vente['transaction_date']}")),
                                        DataCell(Text("${vente['name']}")),
                                        DataCell(Text("${vente['final_total']}")),
                                      ]
                                  )
                              )?.toList()??[],
                          ),
                        ],
                      )
                  ),
                ),
              );
            }
          });
  }}