import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DeliverFood extends StatefulWidget {
  final User user;

  DeliverFood({Key key, this.user}):super(key: key);
  
  @override
  _DeliverFoodState createState() => _DeliverFoodState();
}

class _DeliverFoodState extends State<DeliverFood> {
  String server = "http://lawlietaini.com/hewdeliver";
  double screenHeight, screenWidth;

  @override
  void initState(){
    super.initState();
    _loadEarn();
      }
    
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(title: Text('My Earn',style: TextStyle(letterSpacing: 0.7),),
          backgroundColor: Colors.blueAccent,),
    
          body: Container(
    
          ),
        );
      }
    
      void _loadEarn() {

        
      }
}