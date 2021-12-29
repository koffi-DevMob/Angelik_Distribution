
import 'dart:async';

import 'package:angeliq_distr/MesSQF/BaseDonnees.dart';
import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'dialogBox.dart';

class MainDrawer extends StatefulWidget {

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

String nom="";
Timer _timer;


  Future<bool> checkMission() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String userName = sharedPreferences.getString('userName');
    nom = userName;
    bool check = sharedPreferences.getBool('isMission');
    if (check != null) {
      return check;
    } else {
      check = false;
      return check;
    }
  }

  Future<dynamic> cloturerMission() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt('user_id');
    var urldepense = 'https://angeliquedistribution.asnumeric.com/api/mission/cloturer?added_by=$userId';
    var resultdepense;
    Dio dio = new Dio();
    await dio.get(urldepense).then((response) {
      if (response.statusCode == 200) {
        resultdepense = response.data;
      }
    }).catchError(
            (error) => showMyDialog(msg: 'Veuillez verifier votre connexion !'));
    return resultdepense;
  }

Future syncToMysql()async{
  await SyncronizationData().fetchAllInfo().then((userList)async{
    EasyLoading.show(status: 'SySnchronisation en cours...');
    await SyncronizationData().saveToMysqlWith(userList);
    EasyLoading.showSuccess('Données envoyées');
  });
}


@override
void initState() {
  super.initState();
  //isNet()
  EasyLoading.addStatusCallback((status) {
    print('EasyLoading Status $status');
    if (status == EasyLoadingStatus.dismiss) {
      _timer?.cancel();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkMission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingProgress();
          }
          final bool isMission = snapshot.data;

          return Drawer(
              child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 200.0,
                  padding:
                      EdgeInsets.only(top: 20.0, bottom: 20.0, right: 20.0),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          maxRadius: 30.0,
                          child: Icon(Icons.person),
                        ),
                             title:
                             Text(
                              '$nom',
                              style: style1(),textScaleFactor: 1.1,
                            )


                      )
                    ],
                  )),
              SizedBox(height: 20.0),
              if (!isMission) ...[

              ] else ...[
                 Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Ajouter une Vente',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: bgColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      leading: Icon(
                        Icons.edit,
                      ),
                      onTap: () {
                       Navigator.of(context).pushNamed("/add_sells");
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Ajouter une dépense',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: bgColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      leading: Icon(
                        Icons.edit,
                      ),
                      onTap: () {
                       Navigator.of(context).pushNamed("/add_expense");
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),/*Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'liste',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: bgColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      leading: Icon(
                        Icons.edit,
                      ),
                      onTap: () {
                       Navigator.of(context).pushNamed("/list_local");
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),*/
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Cloturer la Mission',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: bgColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      leading: Icon(
                        Icons.power_settings_new,
                      ),
                      onTap: () async {
                            await SyncronizationData.isInternet().then((connection) async {
                              if (connection) {
                                syncToMysql();
                                if (isMission==true) {
                                  final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                                  int result = await SqfliteDatabaseHelper.instance.deleteData(15);
                                  print('Elements de la table vente supprimés restant: $result / $result');
                                  int resultat = await SqfliteDatabaseHelper.instance.deleteClient(15);
                                   print('Elements de la table client supprimés restant: $resultat / $resultat');

                                  sharedPreferences.setBool('isMission', false);
                                  cloturerMission();
                                  return
                                    Navigator.of(context).pushReplacementNamed('/home');
                                }
                                else {
                                  return
                                    Navigator.of(context).pushNamed("/home");
                                }

                              }
                              else{
                                showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
                              }
                            });



                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Divider(
                  height: 1,
                  color: bgColor.withOpacity(1),
                ),
              ],

              Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Se Deconnecter',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.remove('user_id');
                      sharedPreferences.remove('userName');
                      sharedPreferences.remove('businessId');
                      sharedPreferences.remove('isMission');
                      LoadingProgress();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
              Divider(
                height: 1,
                color: bgColor.withOpacity(0.6),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Propulsé par ASnumeic'),
                ],
              ),
            ],

          )
          );
        });
  }

  Future <Null>dialog(String title)async{
    var context;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Center(child: Text(title , textScaleFactor: 2,)),
          contentPadding: EdgeInsets.all(10),
          children: [
            RaisedButton(
                color:bgColor,
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





