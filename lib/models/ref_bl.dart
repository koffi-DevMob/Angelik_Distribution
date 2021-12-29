// @dart=2.9
import 'package:dio/dio.dart';

class Ref_bl {
  final Map<String, dynamic> reference_bl;

  Ref_bl({
    this.reference_bl});

  Future<void> getElements() async {
    var url = 'https://angeliquedistribution.asnumeric.com/api/refence_bl';
    Dio dio = new Dio();
    await dio.get(url).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> reference_bl = response.data['bonLIvraison'];

      }
    }).catchError((error) => print(error));
  }
}