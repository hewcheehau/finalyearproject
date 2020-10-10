import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

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
  String _ordernotif = "0";
  int _default = 0;
  int _accepeted = 0;
  List itemorder;
  String type = "Today";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadData();
    // getMessage();
    //firebase_Listerners();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text('Order'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          child: RefreshIndicator(
            key: refreshKey,
            color: Colors.blue,
            onRefresh: () async {
              await refreshList();
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Chip(
                          label: Text(
                            'Today',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          avatar: CircleAvatar(
                              // child: Text(_order.toString()),
                              ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      InkWell(
                       onTap: _sortHistory("History"),
                        child: Chip(
                          label: Text('History',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                            //  child: Text(_order.toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: screenHeight * 5.5,
                      width: double.infinity,
                      color: Colors.blue,
                      child: Card(
                          elevation: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Container(
                                    child: Table(
                                      defaultColumnWidth: FlexColumnWidth(1.0),
                                      columnWidths: {
                                        0: FlexColumnWidth(3.5),
                                        1: FlexColumnWidth(6.5)
                                      },
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                              child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text('New Order',
                                                style: TextStyle(
                                                    color:
                                                        Colors.redAccent[700],
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                          TableCell(
                                              child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(_order.toString(),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ))
                                        ]),
                                      ],
                                    ),
                                  )),
                              Divider(
                                color: Colors.black87,
                              ),
                              itemorder == null
                                  ? Flexible(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text('No new order')),
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        itemCount: itemorder.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: GestureDetector(
                                            child: Text(
                                              'Order from tnb',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 30),
                                            ),
                                          ));
                                        },
                                      ),
                                    ),
                              Divider(
                                color: Colors.black87,
                              ),
                              Flexible(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Order Accepted',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.greenAccent[700]),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          _accepeted.toString(),
                                          style: TextStyle(fontSize: 22),
                                        ))
                                      ],
                                    )),
                              ),
                            ],
                          )),
                    ),
                  ),
                )
              ],
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

  void _loadData() async {
    print('enter?order');
    http.post(server + "/php/get_order.php", body: {
      'email': widget.user.email,
      'type': type,
    }).then((res) {
      if (res.body == "noorder") {
        print(res.body);
        setState(() {
          itemorder = null;
        });
      } else {
        print(res.body);
        setState(() {
          var extractdata = json.decode(res.body);
          itemorder = extractdata['order'];
        });
        _countOrder();
      }
    });
  }

  void getMessage() {
    print('send msg');
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

  void _countOrder() {
    for (int i = 0; i < itemorder.length; i++) {
      _order++;
    }
  }

   _sortHistory(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          isDismissible: true, type: ProgressDialogType.Normal);
      pr.style(message: "Loading...");
      pr.show();
      String urlLoadFood = server + "/php/get_order.php";
      http.post(urlLoadFood, body: {
        "type": type,
        
      }).then((res) {
        if (res.body == "noorder") {
          setState(() {
            itemorder = null;
            
           // titlecenter = "No food found.";
          });
          Future.delayed(Duration(seconds: 2)).then((value) {
            pr.hide().whenComplete(() {
              print(pr.isShowing());
            });
          });
        } else {
          setState(() {
          
            var extraction = json.decode(res.body);
            itemorder = extraction["order"];
            FocusScope.of(context).requestFocus(new FocusNode());
            Future.delayed(Duration(seconds: 2)).then((value) {
              pr.hide().whenComplete(() {});
            });
          });
        }
      });
    } catch (e) {
      Toast.show("error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
