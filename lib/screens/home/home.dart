// @dart=2.9
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/screens/home/forms/add_sells.dart';
import 'package:angeliq_distr/screens/home/tableau.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:angeliq_distr/widgets/drawer.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forms/list_vent.dart';


// CETTE APPLICATION FONCTIONNE SANS LA CONNEXION INTERNET

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex =0;
  final tabs = [

    Affiche(),
    ListVentes(),
  ];

  Future<bool> checkMission() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    bool check = sharedPreferences.getBool('isMission');
    if (check != null) {
      return check;
    } else {
      check = false;
      return check;
    }
  }

  String userName;

  Future getUserName()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var name = sharedPreferences.getString('userName');
    setState(() {
      userName = name;
    });
  }

  double _height = .55;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:Colors.white.withOpacity(.9),
      drawer:MainDrawer(),
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 15,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.short_text),
        //   onPressed: (){
        //     scaffoldKey.currentState.openDrawer();
        //   },
        // ),
        title:Text(
              //userName,
              'Angelique Distribution',
            style: style1(),
        ),
        actions: [
          //PopUpOptionMenu()
        ],
       ),
      body:

      tabs[_currentIndex],
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/synchro_client');
          },
          tooltip: 'Ajout Client',
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0)),
          child: Icon(Icons.sync),
          elevation: 8.0,),*/

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedFontSize: 18,
        iconSize: 35,
        unselectedItemColor: bgColor,
        unselectedLabelStyle: style4(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
            backgroundColor: bgColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_sharp),
            label: 'Mes Livraisons',
            backgroundColor: bgColor,)
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),

    );
  }
}

