// @dart=2.9
import 'package:dio/dio.dart';

class Depense {
  final Map<String, dynamic> chefequipes;
  final Map<String, dynamic> categorydepenses;
  final Map<String, dynamic> reference_bl;


  Depense({
    this.chefequipes,
    this.categorydepenses,
    this.reference_bl
  });

  Future<void> getElements() async {
    var url = 'https://angeliquedistribution.asnumeric.com/api/depenses';
    Dio dio = new Dio();
    await dio.get(url).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> chefequipes = response.data['chefequipe'];
        Map<String, dynamic> reference_bl = response.data['reference_bl'];
        Map<String, dynamic> categorydepenses= response.data['categories'];


      }
    }).catchError((error) => print(error));
  }
}