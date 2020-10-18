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
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}