// @dart=2.9
import 'dart:async';

import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:angeliq_distr/screens/home/forms/inputDeco_design.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialMission extends StatefulWidget {
  @override
  _SpecialMissionState createState() => _SpecialMissionState();
}

class _SpecialMissionState extends State<SpecialMission> {
  String mUrl = 'https://angeliquedistribution.asnumeric.com/api/speciale-mission';
  String bonLivraison="";
  String dates;
  int nom;
  var num_chargement;
  DateTime dateChargement;
  int commandId=0, chauffeurId=0, vehiculeId=0;
  bool unSubmit = true;
  String status = "occupé";
  List <int> convoyeur=[];

  //List<String> status = ['Reçu', 'Commandé'];


  Future<dynamic> getElements() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int userId = sharedPreferences.getInt(
        'userId');
    var url = 'https://angeliquedistribution.asnumeric.com/api/orders?mission=speciale';
    var result;
    Dio dio = new Dio();
    await dio.get(url).then((response) {
      if (response.statusCode == 200) {
        result = response.data;
      }
    }).catchError(
        (error) => showMyDialog(msg: 'Veuillez verifier votre connexion !'));
    return result;
  }


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  Future<Null> selectDate(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1940),
        lastDate: DateTime(2030));
    if (datePicker != null && datePicker != date) {
      setState(() {
        date = datePicker;
      });
    }
  }

  Timer _timer;

  Future isNet()async{
    await SyncronizationData.isInternet().then((connection){
      if (connection) {

        print("Internet disponible");
      }else{
        Navigator.pushReplacementNamed(context, '/pas_net_mission');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pas Internet")));
        showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Création de Mission',
          style: style(),
        ),
        centerTitle: true,
      ),
      body: unSubmit
          ?FutureBuilder<dynamic>(
          future:getElements(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingProgress();
            } else {
              print(snapshot.data);
              List<dynamic> commandes = snapshot.data['commandes'];
              List<dynamic> chauffeurs = snapshot.data['chauffeurs'];
              List<dynamic> vehicules = snapshot.data['vehicules'];
              List<dynamic> convoyeurs = snapshot.data['convoyeurs'];
              return
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15,),
                      Center(
                        child: Text('Mission Spéciale',
                            style:style3()),
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),


                            SizedBox(height: 15,),
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: SearchableDropdown.single(
                                  closeButton: 'Fermer',
                                  isExpanded: true,
                                  items: commandes?.map((cmd) {
                                    return (DropdownMenuItem(
                                        value: cmd['id'],
                                        child: Text(cmd['libelle'])));
                                  })?.toList()??[],
                                  value: commandId,
                                  hint: "Veuillez selctionné une commande",
                                  searchHint: "Veuillez selctionné une commande",
                                  onChanged: (val) => commandId = val,
                                  validator: (value) {
                                    if (value == null) {
                                      return null;
                                    } else {
                                      commandId = value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            //ChampDrivers(),

                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: SearchableDropdown.single(
                                  closeButton: 'fermer',
                                  items: chauffeurs?.map((drivers) {
                                    return (
                                        DropdownMenuItem(
                                            value: drivers['id'].toInt(),
                                            child: Text(" ${drivers['nom']} ${drivers['prenom']}")));
                                  })?.toList()??[],
                                  value: chauffeurId,
                                  hint: "Veuillez selctionné un chauffeur",
                                  searchHint: "Veuillez selctionné un chauffeur",
                                  isExpanded: true,
                                  onChanged: (val) => chauffeurId = val,
                                  validator: (value) {
                                    if (value == null) {
                                      return null;
                                    }
                                    {
                                      chauffeurId = value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            //ChampCars(),
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: SearchableDropdown.single(
                                  closeButton: 'Fermer',
                                  items: vehicules?.map((cars) {
                                    return (
                                        DropdownMenuItem(
                                            value: cars['id'].toInt(),
                                            child: Text("${cars['matricule']}")));
                                  })?.toList()??[],
                                  value: vehiculeId,
                                  hint: "Veuillez selctionner un vehicule",
                                  searchHint: "Veuillez selctionner un vehicule",
                                  isExpanded: true,
                                  onChanged: (val) => vehiculeId=val,
                                  validator: (value) {
                                    if (value==null) {
                                      return null;
                                    } else {
                                      vehiculeId = value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            //ChampConvoie(),
                            Container(

                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: SearchableDropdown.multiple(
                                  closeButton: 'Fermer',
                                  items: convoyeurs?.map((convs) {
                                    return(
                                        DropdownMenuItem(
                                            value:('$convs["id"]').toString(),
                                            child: Text(
                                                " ${convs['nom']} ${convs['prenom']} ${convs['telephone']}")));
                                  })?.toList()??[],
                                  //value:convoyeur,
                                  hint: "Veuillez selctionné un convoyeur",
                                  searchHint: "Veuillez selctionné un convoyeur",
                                  isExpanded: true,
                                  onChanged: (val) => convoyeur=val,
                                  validator: (value) {
                                    if (value==null) {
                                      return null;
                                    } else {
                                      convoyeur= value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {

                                    SharedPreferences sharedPreferences =
                                    await SharedPreferences
                                        .getInstance();
                                    final int userId = sharedPreferences.getInt('userId');
                                    final String userName = sharedPreferences.getString('userName');
                                    FormData data = FormData.fromMap({
                                      'chefequipe_id':userId,
                                      'nom':userName,
                                      'status': status,
                                      'commande_id': commandId,
                                      'chauffeur_id': chauffeurId,
                                      'vehicule_id': vehiculeId,
                                      'convoyeur': convoyeur,

                                    });
                                    setState(() {
                                      print('userName:$userName');
                                      print('userId:$userId');
                                      print('status:$status');
                                      print('commandId:$commandId');
                                      print('chauffeurId:$chauffeurId');
                                      print('vehiculeId:$vehiculeId');
                                      print('convoyeur:$convoyeur');

                                    });
                                    Dio dio =  Dio();
                                    await dio
                                        .post(mUrl, data: data)
                                        .then((response) async {
                                      if (response.statusCode == 200) {

                                        print('ok');

                                        if (response.data['success'] !=
                                            null) {
                                          final SharedPreferences
                                          sharedPreferences =
                                          await SharedPreferences
                                              .getInstance();
                                          sharedPreferences.setBool(
                                              'isMission', true);
                                          setState(() {
                                            unSubmit = false;
                                          });
                                          dialog('Mission Spéciale créee');
                                        } else {
                                          Alertdialog('Une donnée manque');
                                          unSubmit = true;
                                          print(response.data['error']);
                                        }
                                      }
                                    }).catchError((error) => print(error));
                                  } else {
                                    print("UnSuccessfull ...");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(50.0),
                                    side: BorderSide(
                                        color:Colors.teal,
                                        width: 1)),
                                textColor: Colors.white,
                                child: Text(
                                  "Créer",
                                  style: style(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
            }
          })
          : LoadingProgress(),

    );
  }

  Future <Null>dialog(String title)async{
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


  Future <Null>Alertdialog(String title)async{
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


