// @dart=2.9
import 'package:angeliq_distr/const/palette.dart';
import 'package:angeliq_distr/screens/home/header.dart';
import 'package:flutter/material.dart';

class Affiche extends StatelessWidget {
  const Affiche({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
      child:
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 285,
              width: double.infinity,
              decoration: BoxDecoration(
                  color:bgColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight:Radius.circular(40)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(0,3),
                    )
                  ]
              ),
              child: Container(
                child: Column(
                  children: [
                    Header(),
                    Acceuil(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25,),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: 350,
                child: Tableau(),
              ),
            )
          ],
        ),
      ),
    );

  }

}