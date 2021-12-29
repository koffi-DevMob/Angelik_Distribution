/*
import 'dart:async';<font></font>
import 'dart:convert';<font></font>
import 'package:flutter/material.dart';<font></font>
import 'package:http/http.dart' as http;<font></font>
import 'package:flutter_svg/flutter_svg.dart';<font></font>
import 'package:stream_example/DataModel.dart';<font></font>
<font></font>
void main() {<font></font>
runApp(MyApp());<font></font>
}<font></font>
<font></font>
class MyApp extends StatelessWidget {<font></font>
// This widget is the root of your application.<font></font>
@override<font></font>
Widget build(BuildContext context) {<font></font>
return MaterialApp(<font></font>
title: 'Flutter Demo',<font></font>
theme: ThemeData(<font></font>
<font></font>
primarySwatch: Colors.blue,<font></font>
),<font></font>
home: HomePage()<font></font>
);<font></font>
}<font></font>
}<font></font>
<font></font>
class HomePage extends StatefulWidget {<font></font>
const HomePage({Key? key}) : super(key: key);<font></font>
<font></font>
@override<font></font>
_HomePageState createState() => _HomePageState();<font></font>
}<font></font>
<font></font>
class _HomePageState extends State<HomePage> {<font></font>
<font></font>
//create stream<font></font>
StreamController<DataModel> _streamController = StreamController();<font></font>
<font></font>
@override<font></font>
void dispose() {<font></font>
// stop streaming when app close<font></font>
_streamController.close();<font></font>
}<font></font>
@override<font></font>
void initState() {<font></font>
// TODO: implement initState<font></font>
super.initState();<font></font>
<font></font>
// A Timer method that run every 3 seconds<font></font>
<font></font>
Timer.periodic(Duration(seconds: 3), (timer) {<font></font>
getCryptoPrice();<font></font>
});<font></font>
<font></font>
}<font></font>
<font></font>
// a future method that fetch data from API<font></font>
Future<void> getCryptoPrice() async{<font></font>
<font></font>
var url = Uri.parse('https://api.nomics.com/v1/currencies/ticker?key=your_api_key&ids=DOGE');<font></font>
<font></font>
final response = await http.get(url);<font></font>
final databody = json.decode(response.body).first;<font></font>
<font></font>
DataModel dataModel = new DataModel.fromJson(databody);<font></font>
<font></font>
// add API response to stream controller sink<font></font>
_streamController.sink.add(dataModel);<font></font>
}<font></font>
<font></font>
@override<font></font>
Widget build(BuildContext context) {<font></font>
return Scaffold(<font></font>
body: Center(<font></font>
child: StreamBuilder<DataModel>(<font></font>
stream: _streamController.stream,<font></font>
builder: (context,snapdata){<font></font>
switch(snapdata.connectionState){<font></font>
case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);<font></font>
default: if(snapdata.hasError){<font></font>
return Text('Please Wait....');<font></font>
}else{<font></font>
return BuildCoinWidget(snapdata.data!);<font></font>
}<font></font>
}<font></font>
},<font></font>
),<font></font>
),<font></font>
);<font></font>
}<font></font>
<font></font>
Widget BuildCoinWidget(DataModel dataModel){<font></font>
return Center(<font></font>
child: Column(<font></font>
mainAxisAlignment: MainAxisAlignment.center,<font></font>
children: [<font></font>
Text('${dataModel.name}',style: TextStyle(fontSize: 25),),<font></font>
SizedBox(height: 20,),<font></font>
SvgPicture.network('${dataModel.image}',width: 150,height: 150,),<font></font>
SizedBox(height: 20,),<font></font>
Text('\$${dataModel.price}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)<font></font>
],<font></font>
),<font></font>
);<font></font>
}<font></font>
}<div class="open_grepper_editor" title="Modifier et enregistrer dans Grepper"></div>
*/
