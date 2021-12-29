// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:angeliq_distr/MesSQF/Controller.dart';
import 'package:angeliq_distr/MesSQF/ModelClient.dart';
import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class SynchroClient extends StatefulWidget {
  @override
  _SynchroClient createState() => _SynchroClient();
}

class _SynchroClient extends State<SynchroClient> {

  int id=0;
  String name ="",mobile="";
  bool unSubmit = true;


  Future<dynamic> getAllClient() async {
    var urlclient =  'https://angeliquedistribution.asnumeric.com/api/customers';
    var resultclient;
    Dio dio = new Dio();
    await dio.get(urlclient).then((response) {
      if (response.statusCode == 200) {
        //client = json.decode(response.data);
        resultclient=response.data;
      }
    }).catchError(
            (error) => showMyDialog(msg: 'Veuillez verifier votre connexion !'));
    return resultclient;
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Timer _timer;

  List listes;
  bool loading = true;

  Future isNet()async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
        print("Internet disponible");
      } else {
        Navigator.pushReplacementNamed(context, '/pas_net_mission');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pas Internet")));
        showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
      }
    });
  }
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remplir ma BD',
          style: style(),
        ),
        centerTitle: true,
      ),

      body: unSubmit?
      FutureBuilder<dynamic>(
          future: getAllClient(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingProgress();
            } else {
              List<dynamic> customers = snapshot.data;
              List<String> client = [];
              customers?.map((data) => client)?.toList()??[];

              print(customers);
              return Container(
                child: Center(
                  child: GestureDetector(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                child:Row(
                                children: [
                                  Expanded(child:
                                  Text('Liste Clients',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:bgColor ),),),
                                  Expanded(
                                    child: SizedBox(
                                        width: 120,
                                        height: 50,
                                        child: RaisedButton(
                                          color: Colors.teal,
                                          onPressed: () async {
                                            customers.forEach((val) {
                                              ClientModel clientModel = ClientModel.fromJson(val);
                                               Controller().addClient(clientModel).then((value) {
                                                if (value != 0) {
                                                  print("Success");
                                                }
                                                else {
                                                  print("Non envoyé");
                                                }
                                              });
                                            });
                                            LoadingProgress();
                                            /*setState(() {
                                              for(var i=0; i < customers.length; i++){
                                                print('id:$id');
                                                print('name:$name');
                                                print('mobile:$mobile');
                                              }
                                            });*/
                                            dialogue("Synchro effectuée");
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  width: 1)),
                                          textColor: Colors.white,
                                          child: Text(
                                            "Sauvegarder",
                                            style: style(),
                                          ),
                                        )
                                    ),
                                  )

                                ],
                              ),),
                            ),
                            SizedBox(height: (50),),
                            DataTable(
                                columns: [
                                  DataColumn(label: Text('Id', style: style())),
                                  DataColumn(label: Text('Nom', style: style())),
                                  DataColumn(label: Text('Mobile', style: style())),
                                ],
                                rows:
                                customers?.map((clients) {
                                  id=clients['id'];
                                  name=clients['name'];
                                  mobile=clients['mobile'];

                                  return DataRow(
                                      cells: [
                                        DataCell(Text("${id}")),
                                        DataCell(Text("${name}")),
                                        DataCell(Text("${mobile}")),
                                      ]
                                  );
                                })?.toList()??[],
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              );
            }
          })
          :LoadingProgress(),
    );
  }


  Future <Null>dialogue(String title)async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Center(child: Text(title , textScaleFactor: 1,)),
          contentPadding: EdgeInsets.all(10),
          children: [
            RaisedButton(
                color: bgColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, '/home');
                })
          ],);
      },
    );
  }

}