// @dart=2.9
import 'dart:async';
import 'package:angeliq_distr/MesSQF/Controller.dart';
import 'package:angeliq_distr/MesSQF/TableModel.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:angeliq_distr/screens/home/forms/inputDeco_design.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSellsForm extends StatefulWidget {
  @override
  _AddSellsForm createState() => _AddSellsForm();
}

class _AddSellsForm extends State<AddSellsForm> {

  String mUrl = 'https://angeliquedistribution.asnumeric.com/api/sells';
  final int id_b6=1;
  final int id_b12=2;
  int final_total=0;
  int amount;
  int clientId=0;
  int Qtiteb12,Qtiteb6,contact_id,user_id;
  bool unSubmit = true;

  Future<dynamic> getElementsClient;

  Future<dynamic> getAllClient() async {
    var urlclient =  'http://angeliquedistribution.asnumeric.com/api/customers';
    var resultclient;
    Dio dio = new Dio();
    await dio.get(urlclient).then((response) {
      if (response.statusCode == 200) {
        resultclient = response.data;
      }
    }).catchError(
            (error) => showMyDialog(msg: 'Veuillez verifier votre connexion !'));
    return resultclient;
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

  List list;
  List listes;
  bool loading = true;
  Future userList()async{
    list = await Controller().fetchData();
    setState(() {loading=false;});
    //print(list);
  }

  @override
  void initState() {
    super.initState();
    userList();
    //isNet()
    getElementsClient =Controller().fetchAllClient();
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

        title: Text('Ventes'),
        centerTitle: true,
      ),

      body: unSubmit?
      FutureBuilder<dynamic>(
          future: getElementsClient,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingProgress();
            } else {
              List<dynamic> customers = snapshot.data;
              List<String> client = [];

              customers?.map((data) => client)?.toList()??[];

             print(snapshot.data);
              return Container(
                child: GestureDetector(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          Center(
                            child: Text('Nouvelle vente',
                                style: style3()),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: SearchableDropdown.single(
                              closeButton: 'Fermer',
                              items: customers?.map((clients) {
                                return (
                                    DropdownMenuItem(
                                        value: clients['id'],
                                        child: Text("${clients['name']} | ${clients['mobile']}")));
                              })?.toList()??[],
                              value: clientId,
                              hint: "Veuillez selctionné un client",
                              searchHint: "Veuillez selctionné un client",
                              onChanged: (val) => clientId = val,
                              isExpanded: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              decoration: buildInputDecoration(
                                  Icons.confirmation_number_outlined,
                                  'Quantité B6'),
                              autocorrect: true,
                              autofocus: true,
                              onChanged: (val) {
                                Qtiteb6 = int.tryParse(val);
                              },
                              // onSaved: (val)=>db.values['Qtiteb6'] = val,
                              keyboardType: TextInputType.number,

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              decoration: buildInputDecoration(
                                  Icons.confirmation_number_outlined,
                                  'Quantité B12'),
                              autocorrect: true,
                              autofocus: true,
                              onChanged: (val) {
                                Qtiteb12 = int.tryParse(val);
                              },
                              //onSaved: (val)=>db.values['Qtite12'] = val,
                              keyboardType: TextInputType.number,
                            ),
                          ),


                          Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 20, right: 5),
                                    child: Text(
                                      "$final_total fcfa", style: style3(),),
                                  ),
                                ),

                                Expanded(child:

                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, left: 30, right: 20),
                                    child: RaisedButton(
                                      color: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0),
                                          side: BorderSide(
                                              color:
                                              Theme
                                                  .of(context)
                                                  .primaryColor,
                                              width: 1)),
                                      child: Text("Calculer", style: style1(),),
                                      onPressed: calculs,
                                    )
                                ))
                              ]
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              // onChanged: (value) => filteredClients(value),
                              decoration: buildInputDecoration(
                                  Icons.aspect_ratio, "Montant Reçu"),
                              onChanged: (val) {
                                amount = int.tryParse(val);
                              },

                              //onSaved: (val)=>db.values['amount'] = val,
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                              width: 200,
                              height: 50,
                              child: RaisedButton(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                onPressed: () async {
                                  if(clientId == 0 || final_total == 0 || amount == null){
                                    dial("Veuillez Remplir les champs");
                                  }else{
                                    Envoi();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(50.0),
                                    side: BorderSide(
                                        color: Colors.teal,
                                        width: 1)),
                                textColor: Colors.white,
                                child: Text(
                                  "Enregistrer",
                                  style: style(),
                                ),
                              )
                          )
                        ],
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
  Future <Null>dial(String title)async{
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

  void calculs(){
    if(Qtiteb6!=null && Qtiteb12!=null){
      final_total=((Qtiteb12*4850)+(Qtiteb6*1850)).toInt();
      setState(() {
        context;
      });
    }
  }

  Future Envoi() async {
    SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    int userId = sharedPreferences.getInt(
        'userId');
    user_id = userId;
    ItemModel contactinfoModel =
    ItemModel(
      id: null,
      id_b6: 1,
      id_b12: 2,
      Qtiteb6: Qtiteb6,
      Qtiteb12: Qtiteb12,
      user_id: user_id,
      contact_id: clientId,
      final_total: final_total,
      amount: amount,
    );
    await Controller()
        .addData(contactinfoModel)
        .then((value) {
      if (value > 0) {
        print("Success");
        userList();
      }
      else {
        print("Non envoyé");
      }
    });
    LoadingProgress();
    setState(() {
      print('userd_id:$user_id');
      print('id_B6:$id_b6');
      print('id_B12:$id_b12');
      print('contact_Id:$clientId');
      print('Qtiteb6:$Qtiteb6');
      print('Qtiteb12:$Qtiteb12');
      print('final_total:$final_total');
      print('amount:$amount');
    });
    // int resultat = await SqfliteDatabaseHelper.instance.deleteClient(200);
    // print('Elements de la table client supprimés restant: $resultat');
    dialogue("Vente effectuée");
  }

}


