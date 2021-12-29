import 'dart:async';

import 'package:angeliq_distr/MesSQF/Controller.dart';
import 'package:angeliq_distr/MesSQF/Syncro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ListLocal extends StatefulWidget {

  @override
  _ListLocalState createState() => _ListLocalState();
}

class _ListLocalState extends State<ListLocal> {
  Timer _timer;

  bool loading = true;

  List list;

  Future userList()async{
    list = await Controller().fetchData();
    setState(() {loading=false;});
    //print(list);
  }

  Future isInteret()async{
    await SyncronizationData.isInternet().then((connection){
      if (connection) {

        print("Internet connection abailale");
      }else{
        print("No Internet connection abailale");
      }
    });
  }

  void initState() {
    super.initState();
    userList();
    isInteret();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return loading? Center(child: CircularProgressIndicator()):Expanded(
      child: ListView.builder(
        itemCount: list.length==null?0:list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list[index]['id'].toString()),
                SizedBox( width: 5,),
                Text(list[index]['id_b6'].toString()),
                SizedBox( width: 5,),
                Text(list[index]['id_b12'].toString()),
                 SizedBox( width: 5,),
                 Text(list[index]['Qtiteb6'].toString()),
                 SizedBox( width: 5,),
                 Text(list[index]['Qtiteb12'].toString()),
                SizedBox( width: 5,),
                 Text(list[index]['amount'].toString()),
                 SizedBox( width: 5,),
                 Text(list[index]['final_total'].toString()),
                 SizedBox( width: 5,),
                Text(list[index]['contact_id'].toString()),
              ],),
          );
        },
      ),
    );
  }
}
