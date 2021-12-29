// @dart=2.9

import 'dart:async';

import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:angeliq_distr/screens/home/forms/inputDeco_design.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseForm createState() => _AddExpenseForm();
}

class _AddExpenseForm extends State<AddExpenseForm> {

  String mUrl = 'https://angeliquedistribution.asnumeric.com/api/expenses';
  bool unSubmit = true;
  String bonLivraison="";
  String dates;
 dynamic ref_no;
  int  chefequipId,categoriesId;
  var montant;
  Map depense = Map();


  Future<dynamic> getElementsDepense() async {
     SharedPreferences sharedPreferences =
         await SharedPreferences.getInstance();
     final int userId = sharedPreferences.getInt(
         'user_id');
     var urldepense = 'https://angeliquedistribution.asnumeric.com/api/depenses?chefequipeId=$userId';
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



  DateTime date = DateTime.now();
  Future<Null> selectDate(BuildContext context)  async{
    DateTime datePicker = await showDatePicker(
        context:context,
        initialDate:date,
        firstDate: DateTime(1940),
        lastDate: DateTime(2030)
    );
    if(datePicker != null && datePicker != date){
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


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajoute de Dépense',
          style: style(),
        ),
        centerTitle: true,
      ),
      body:unSubmit

         ?FutureBuilder<dynamic>(
              future:getElementsDepense(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingProgress();
                } else {
                  print(snapshot.data);
                  //List<dynamic> chefequipes = snapshot.data['chefequipes'];
                  List<dynamic> categorydepenses = snapshot.data['categorydepenses'];
                  String bl_fournisseur = snapshot.data['bl_fournisseur'];
                  return
                    GestureDetector(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,),
                              Text("Nouvelle Depense", style: style3(),),

                              SizedBox(height: 15,),

                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: TextFormField(
                                  readOnly: true,
                                  //onTap: () => setState(() => selectDate(context)),
                                  decoration: buildInputDecoration(Icons
                                      .date_range, f.format(date)),
                                  validator: (String value) {
                                    value = f.format(date);
                                    if (value.isEmpty) {
                                      value = f.format(date);
                                      return 'Veuillez selectionner une date';
                                    }
                                    dates=value;
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: TextFormField(
                                  decoration: buildInputDecoration(
                                      Icons.format_list_numbered,
                                      "$bl_fournisseur"),
                                  autocorrect: true,
                                  readOnly: true,
                                  autofocus: true,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
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
                                      bottom: 10, left: 10, right: 10),
                                  child: SearchableDropdown.single(
                                    closeButton: 'fermer',
                                    value: categoriesId,
                                    items: categorydepenses?.map((catego) {
                                      return(
                                          DropdownMenuItem(
                                              value: catego['id'],
                                              child: Text("${catego['name']}")));
                                    })?.toList()??[],
                                    hint: "Veuillez selctionné une categorie",
                                    searchHint: "Veuillez selctionné une categorie",
                                    isExpanded: true,
                                    onChanged: (val) => categoriesId = val,
                                    validator: (value) {
                                      if (value == null) {
                                        return null;
                                      }
                                      {
                                        categoriesId = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: buildInputDecoration(Icons.money,
                                      "Montant"),

                                  initialValue:null,
                                  validator: (value) {
                                    if (value==null) {
                                      return 'Veuillez entrer le montant de la dépense';
                                    }
                                     montant = value;
                                    return null;
                                  },
                                ),
                              ),

                              SizedBox(height: 50,),

                              SizedBox(
                                width: 200,
                                height: 50,
                                child: RaisedButton(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      SharedPreferences sharedPreferences =
                                      await SharedPreferences
                                          .getInstance();
                                      final int userId = sharedPreferences.getInt(
                                          'userId');
                                      FormData data = FormData.fromMap({
                                        'expense_category_id':categoriesId,
                                        'transaction_date': dates,
                                        'reference_bl': bl_fournisseur,
                                        'depense[0][cat_id]':categoriesId,
                                        'depense[0][montant]':montant,
                                        'chefequipe_id': userId,
                                        'ref_no':ref_no,
                                      });

                                      setState(() {
                                        print('bonLivraison:$bl_fournisseur');
                                        print('categoriesId:$categoriesId');
                                        print('dates:$dates');
                                        print('montant:$montant');
                                        print('depense:$depense');
                                        print('userdId:$userId');
                                        print('ref:$ref_no');
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
                                            //Si je change isMission en true la mission sera toujours en cours
                                            setState(() {
                                              unSubmit = false;
                                            });
                                           Alertdialogue("Depense Ajoutée");
                                          } else {

                                            setState(() {
                                              unSubmit = true;
                                            });

                                            print(response.data['error']);
                                          }

                                        }

                                      }).catchError((error) => print(error));
                                    }
                                    else {
                                      print("UnSuccessfull");
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: Theme
                                          .of(context)
                                          .primaryColor, width: 1)
                                  ),
                                  textColor: Colors.white,
                                  child: Text("Enregistrer"),

                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
              }
              }  )
      :LoadingProgress(),
    );
  }

  Future <Null>dialog(String title)async{
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

  Future <Null>Alertdialogue(String title)async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Center(child: Text(title , textScaleFactor: 1.5,)),
          content:SingleChildScrollView(
           child: ListBody(
            children: [
              Text("Voulez-vous ajouter une autre depense",textScaleFactor: 1,),
            ],
          )
        ),
            actions: [
              FlatButton(onPressed: (){
                Navigator.pushReplacementNamed(
                    context, '/home');
              }, child: Text("NON",style:TextStyle(color:Colors.red)),),
              FlatButton(onPressed: (){
                Navigator.pushReplacementNamed(
                    context, '/add_expense');
              }, child: Text("OUI",style:TextStyle(color:Colors.blue)),),
          ],
          elevation: 25,
        );
      },
    );
  }


}
