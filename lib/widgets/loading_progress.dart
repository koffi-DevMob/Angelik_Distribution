// @dart=2.9
import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(

        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueGrey[900]),
        )
    );
  }
}