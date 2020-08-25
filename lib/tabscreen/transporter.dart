import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';


class TransporterScreen extends StatefulWidget {
  final User user;
  const TransporterScreen({Key key,this.user}):super(key:key);

  @override
  _TransporterScreenState createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        elevation: 10,
        backgroundColor: Colors.blueAccent,
        title: Text('Today Order',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize: 22)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}