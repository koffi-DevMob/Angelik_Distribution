
import 'package:angeliq_distr/screens/home/forms/Listlocal.dart';
import 'package:angeliq_distr/screens/home/forms/aad_client.dart';
import 'package:angeliq_distr/screens/home/forms/add_sells.dart';
import 'package:angeliq_distr/screens/home/forms/add_expense.dart';
import 'package:angeliq_distr/screens/home/forms/list_vent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import  'package:angeliq_distr/screens/auth/login.dart';
import 'package:angeliq_distr/screens/wrapper.dart';
import 'package:angeliq_distr/screens/home/home.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'MesSQF/BaseDonnees.dart';
import 'MesSQF/Controller.dart';
import 'provider/userProvider.dart';
import 'package:angeliq_distr/screens/home/drawer-items/mission.dart';

import 'screens/home/drawer-items/NoNetMission.dart';
import 'widgets/dialogBox.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteDatabaseHelper.instance.db;
  runApp(Angelik());
configLoading();

  }


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class Angelik extends StatelessWidget {
  static const Map<int,Color> colorMap = {
    50: Color.fromRGBO(42, 54, 59, 0.1),
    100: Color.fromRGBO(42, 54, 59, 0.2),
    200: Color.fromRGBO(42, 54, 59, 0.3),
    300: Color.fromRGBO(42, 54, 59, 0.4),
    400: Color.fromRGBO(42, 54, 59, 0.5),
    500: Color.fromRGBO(42, 54, 59, 0.6),
    600: Color.fromRGBO(42, 54, 59, 0.7),
    700: Color.fromRGBO(42, 54, 59, 0.8),
    800: Color.fromRGBO(42, 54, 59, 0.9),
    900: Color.fromRGBO(42, 54, 59, 1.0),
  };





  static const MaterialColor _teal = MaterialColor(0xFF212332, colorMap);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => UserProvider(),)
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
          initialRoute:'/',
          routes: {
             '/':(context) => Wrapper(),
            '/login':(context) => LoginSignupScreen(),
            '/home':(context) => Home(),
            '/add_sells':(context) => AddSellsForm(),
            '/add_expense':(context) => AddExpenseForm(),
            '/list_vent':(context) => ListVentes(),
            '/list_local':(context) => ListLocal(),
            '/mission' : (context) => Mission(),
            '/pas_net_mission' : (context) => NoNetMission(),
            '/synchro_client' : (context) => SynchroClient(),
          },
        theme: ThemeData(
        primarySwatch: _teal,
        fontFamily: 'Quicksand',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        ),

    );
  }
}
