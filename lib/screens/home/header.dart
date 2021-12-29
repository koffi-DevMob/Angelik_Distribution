// @dart=2.9
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/const/text_style.dart';
import 'package:angeliq_distr/screens/home/home.dart';
import 'package:angeliq_distr/widgets/loading_progress.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer-items/mission.dart';
import 'drawer-items/special_mission.dart';

class Header extends StatelessWidget {
  get context => Header();
  int num_bl=0;


  Future<bool> checkMission() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final int reference_bl = sharedPreferences.getInt('reference_bl');
    bool check = sharedPreferences.getBool('isMission');
    num_bl=reference_bl;
    if (check != null) {
      return check;
    } else {
      check = false;
      return check;
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // dynamic mediaQuery = MediaQuery.of(context);
        future: checkMission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingProgress();
          }
          final bool isMission = snapshot.data;
          return SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  color: bgColor,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            if (!isMission) ...[

                            ]else ...[
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Mission en cours!",style:TextStyle(
                                    color:Colors.red, fontFamily: "Nunito",
                                    fontWeight: FontWeight.w200,fontSize: 14,
                                  )),
                                ],),
                            ],
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(onPressed: () {
                                  if (isMission==true) {
                                   return null;
                                  }
                                  else {
                                    return
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Mission()),);
                                  }

                                },
                                  color: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Container(
                                    width: 124,
                                    height: 90,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        const Icon(Icons.playlist_add,
                                            color: Colors.white),
                                        const SizedBox(width: 4,),
                                        Text(
                                          "Mission",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                RaisedButton(onPressed: () {
                                  if (isMission==true) {
                                    return affiche();
                                  }
                                  else {
                                    return
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  SpecialMission()),);
                                  }
                                },
                                  color: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Container(
                                    width: 124,
                                    height: 90,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        const Icon(Icons.playlist_add,
                                            color: Colors.white),
                                        const SizedBox(width: 5,),
                                        Text(
                                          "Spéciale",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                      )
                  )
              )
          );
        }
    );
  }


  Future<Null> affiche() async {
    return showDialog(
      context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            children:[
              Text("Votre besoin de base est "),
              RaisedButton(onPressed: () {
                Navigator.pop(buildContext);
              },
                child: Text("OK",style: style1(),),
                color:Colors.teal,
              )
            ],
          );
        }
    );
  }

}

class Acceuil extends StatelessWidget {
  const Acceuil({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(

        width: double.infinity,
        //color: bgColor,
        child: Padding(
        padding: const EdgeInsets.all(15.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
   children: [
     Container(
       padding: EdgeInsets.all(defaultPadding),
       decoration: BoxDecoration(
         color: secondaryColor,
         border: Border.all(width: 0.5,
           color:Colors.blueGrey,
         ),
         borderRadius: const BorderRadius.all(
             Radius.circular(defaultPadding)),
       ),
       child: Row(
         children: [
           SizedBox(
               width: 25,
               height: 25,
               child:
               Icon(Icons.local_shipping_outlined,color: Colors.red,size: 30,)
           ),
           Expanded(child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "LIVRAISON DANS TOUT LE PAYS",
                       maxLines:1,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 15,),
                     ),

                   ],
                 )
               ],
             ),
           ))
         ],
       ),
     ),
     SizedBox(height: 25,),

   ],

    ),

        ),

        )
    );
  }
}


class Tableau extends StatelessWidget {
  const Tableau({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15,right: 15),
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   // Image.asset('images/B6.jpeg',),
                    Image.asset('images/b12.jpeg',),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
      /**/
    );

  }

}