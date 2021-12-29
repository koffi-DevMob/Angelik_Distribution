import 'package:angeliq_distr/const/text_style.dart';
import 'package:flutter/material.dart';

class NoNetMission extends StatefulWidget {
  const NoNetMission({Key key}) : super(key: key);

  @override
  _NoNetMissionState createState() => _NoNetMissionState();
}

class _NoNetMissionState extends State<NoNetMission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vérification de connexion',
          style: style(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Pas de Connexion'),
      ),
    );
  }
}
