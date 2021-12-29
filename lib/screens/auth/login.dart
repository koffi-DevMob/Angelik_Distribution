// @dart=2.9
import 'dart:async';

import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/screens/home/forms/inputDeco_design.dart';
import 'package:angeliq_distr/widgets/request-loader.dart';
import 'package:angeliq_distr/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:angeliq_distr/widgets/dialogBox.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userName="",password="";
  bool isLoading = false;
  final uri = 'https://angeliquedistribution.asnumeric.com/api/auth';

  Connexion() async {
    if(_formkey.currentState.validate())
    {
      setState(() {
        isLoading = true;
      });
      FormData _formData = new FormData.fromMap(
          {
            "username" : userName,
            "password" : password
          }
      );
      await Provider.of<UserProvider>(context,listen: false)
          .login(_formData)
          .then((res){
        print("res['user_id']:$res[]");
        if(res['status'] && res['netWorkStatus']){
          var vertest = res['user_id'];
          print('userName:$vertest');
          Navigator.pushReplacementNamed(context, '/home');
        }else if(!res['status'] && res['netWorkStatus']){
          setState(() {
            isLoading = false;
          });
          showMyDialog(context:context,msg:'Login ou mot de passe incorrect !', route:'/');
        }
        else if(res['status'] && !res['netWorkStatus']){
          setState(() {
            isLoading = false;
          });
          showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
        }
        else if(!res['status'] && !res['netWorkStatus']){
          setState(() {
            isLoading = false;
          });
          showMyDialog(context:context,msg:'Veuillez verifier votre connexion !',route: '/');
        }
      }
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(5), // here the desired height
          child: AppBar(
            backgroundColor:Palette.backgroundColor,
            // ...
          )
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/b12.jpeg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.only(top: 100, left: 20),
                color: Color(0xFF3b5999).withOpacity(.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Bienvenue Chez Angelique Distribution",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height:350,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.only(left: 20,right: 20,top: 240),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Connexion",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:  Palette.activeColor
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Form(
                        key: _formkey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                  validator: (String value) {
                                    if(value.isEmpty){
                                      return 'Veuillez entrer le nom d\'utilisateur';
                                    }else{
                                      userName = value;
                                      return null;
                                    }
                                  },
                                  keyboardType:TextInputType.text,
                                  decoration: buildInputDecoration(Icons.person, 'Veuillez entrer le nom d\'utilisateur')
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                  validator: (String value) {
                                    if(value.isEmpty){
                                      return 'Veuillez entrer votre mot de passe';
                                    }else{
                                      password = value;
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  keyboardType:TextInputType.text,
                                  decoration: buildInputDecoration(MaterialCommunityIcons.lock_outline, 'Veuillez votre nom de passe')
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    Connexion();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: Theme.of(context).primaryColor,width:1)
                                  ),
                                  textColor:Colors.white,child: Text("Se Connecter"),

                                ),
                              )
                            ],
                          )
                      ),
                    )
                  ],
                ),
            ),
          ),
          isLoading ? requestLoader() : SizedBox()
        ],
      ),
    );
  }
}
