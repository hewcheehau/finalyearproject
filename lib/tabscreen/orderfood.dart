import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}



class OrderFoodPage extends StatefulWidget {
  final User user;

  const OrderFoodPage({Key key, this.user}) : super(key: key);

  @override
  _OrderFoodPageState createState() => _OrderFoodPageState();
}

class _OrderFoodPageState extends State<OrderFoodPage> {
  String _message = '';
 // String token1;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  GlobalKey<RefreshIndicatorState> refreshKey;
  String server = "http://lawlietaini.com/hewdeliver";
  int _count = 0;
  int _order = 0;

  _register() {
    _fcm.getToken().then((token) => print(token));
  }

/*  void firebase_Listerners() {
    _fcm.getToken().then((token) {
      print('Token is ' + token);
      token1 = token;
      setState(() {});
    });
  }*/

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getMessage();
    //firebase_Listerners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: Text('Order'),
         
        ),
        body: Center(
          child: Container(
            child: RefreshIndicator(
              key: refreshKey,
              color: Colors.blue,
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                alignment: Alignment.topLeft,
                child: Row(
                  
                  children: <Widget>[
                  Chip(
                    label: Text('Today',style: TextStyle(fontWeight:FontWeight.bold,fontSize:18),),
                    avatar: CircleAvatar(
                      child: Text(_order.toString()),
                    ),
                    
                  ),
                  SizedBox(width:8.0),
                   Chip(
                    label: Text('History',style: TextStyle(fontWeight:FontWeight.bold,fontSize:18)),
                    avatar: CircleAvatar(
                      child: Text(_order.toString()),
                    ),
                  ),
                ],),

            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  void _loadData() {

    http.post(server+"/php/get_order.php",body: {

      'email' : widget.user.email,

    });

  }

  void getMessage() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Ok'))
                ],
              ));
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onMessage: $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      
    });
  }

  Future _getQue() async {
    print('enter');
   
  }
}
