// @dart=2.9
import 'package:dio/dio.dart';

 class Orders {
   final Map<String, dynamic> commandes;
   final Map<String, dynamic> vehicules;
   final Map<String, dynamic> convoyeurs;
   final Map<String, dynamic> chauffeurs;
   final Map<String, dynamic> customers;

   Orders({
     this.commandes,
     this.vehicules,
     this.chauffeurs,
     this.convoyeurs,
     this.customers
   });

   Future<void> getElements() async {
     var url = 'https://angeliquedistribution.asnumeric.com/api/orders';
     Dio dio = new Dio();
     await dio.get(url).then((response) {
       if (response.statusCode == 200) {
         Map<String, dynamic> commandes = response.data['orders'];
         Map<String, dynamic> vehicules = response.data['cars'];
         Map<String, dynamic> convoyeurs = response.data['convoyeur'];
         Map<String, dynamic> chauffeurs = response.data['chauffeur'];
         Map<String, dynamic> customers = response.data['customers'];

     }
    }).catchError((error) => print(error));
   }
 }

// // https://stackoverflow.com/questions/56752690/how-to-display-list-of-map-into-dropdownmenuitem-in-flutter
// // https://stackoverflow.com/questions/57430655/hint-not-working-for-dropdownbuttonformfield-in-flutter
// //  https://bezkoder.com/dart-convert-list-map/