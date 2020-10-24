import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:fypv1/user.dart';
import 'package:fypv1/deliver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:fypv1/order/completedeliver.dart';

class DeliverDetail extends StatefulWidget {
  final User user;
  final Deliver deliver;

  DeliverDetail({Key key, this.user, this.deliver}) : super(key: key);

  @override
  _DeliverDetailState createState() => _DeliverDetailState();
}

class _DeliverDetailState extends State<DeliverDetail> {
  double screenHeight, screenWidth;
  String server = "http://lawlietaini.com/hewdeliver";
  bool _isVisible = false;
  String _current = "Picking food";
  @override
  void initState() {
    super.initState();
    if(widget.deliver.status=='deliver'){
      _current = 'Delivering food to customers';
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery detail'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.delete_forever_rounded), onPressed: () {})
        ],
        leading: IconButton(icon: Icon(Icons.remove), onPressed: ()=>{Navigator.of(context).pop(true)}),
      ),
      body: Container(
        height: screenHeight * 100,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  height: screenHeight / 1.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Icon(
                          Icons.delivery_dining,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Food seller',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            columnWidths: {
                              0: FlexColumnWidth(3.5),
                              1: FlexColumnWidth(6.5)
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Order ID: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.orderid}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Delivery ID#: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.taskid}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Food shop: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.foodshop}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Phone No. : ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.foodphone}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Customer detail',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            columnWidths: {
                              0: FlexColumnWidth(3.5),
                              1: FlexColumnWidth(6.5)
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Order ID: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.orderid}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Delivery ID#: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.taskid}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Customer name: ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.custname}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Phone No. : ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.custphone}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                                 TableRow(children: [
                                TableCell(
                                    child: Text(
                                  "Cust Address : ",
                                  style: TextStyle(fontSize: 18),
                                )),
                                TableCell(
                                    child: Text(
                                  "${widget.deliver.address}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        widget.deliver.raider == widget.user.email
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          'Payment: COD',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        Container(
                                          height: 20,
                                          child: VerticalDivider(
                                              color: Colors.black),
                                        ),
                                        Expanded(
                                            child: Text('Total price: RM14',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    ),
                                    Divider(),
                                    _current == 'Delivering food to customers'
                                        ? MaterialButton(
                                            minWidth: 250,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.blueAccent,
                                            onPressed: () => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CompleteDeliverScreen(user: widget.user,deliver: widget.deliver,))).then((value) => setState((){}))
                                                },
                                            child: Text('Complete Delivery',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)))
                                        : MaterialButton(
                                            minWidth: 250,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.blueAccent,
                                            onPressed: () =>
                                                {_onCompletePickup()},
                                            child: Text('Complete Pick Up',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white))),
                                    MaterialButton(
                                        minWidth: 250,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: Colors.redAccent,
                                        onPressed: () {},
                                        child: Text('Emergence Abanddon',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                          shape: Border.all(),
                                          color: Colors.blueAccent,
                                          onPressed: () =>
                                              {_onAccepetDelivery()},
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      '(Click accept to receive this delivery task)'),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onAccepetDelivery() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Align(
                  alignment: Alignment.center, child: Text('Are you sure?')),
              content: Text('You are assigned as raider to deliver food'),
              actionsOverflowButtonSpacing: 5,
              actionsPadding: EdgeInsets.all(5),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _goToAssignOrder();
                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                MaterialButton(
                  onPressed: () => {Navigator.of(context).pop(false)},
                  child: Text('No',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                )
              ],
            ));
  }

  void _goToAssignOrder() async {
    await http.post(server + "/php/accept_deliver.php", body: {
      'email': widget.user.email,
      'orderid': widget.deliver.orderid,
      'taskid': widget.deliver.taskid
    }).then((res) {
      if (res.body == 'success') {
        _showSuccessful();
        setState(() {});
      } else {
        print(res.body);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _showSuccessful() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('assign', 1);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Assigned successfully'),
            content: Icon(
              Icons.check_circle_outline,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                   
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Ok'))
            ],
          );
        });
        Navigator.of(context).pop(true);
  }

  _onCompletePickup() {
    ProgressDialog pr = ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    pr.style(message: 'Updating...');
    pr.show();

    String _pickComplete = "pick";
    http.post(server + "/php/update_deliver.php", body: {
      'email': widget.user.email,
      'current': _pickComplete,
      'orderid': widget.deliver.orderid
    }).then((res) {
      if (res.body == 'success') {
          _showSuccessPick();
        Future.delayed(Duration(seconds: 2)).then((value) => {
              pr.hide().whenComplete(() => {print(pr.isShowing())})
            });
        _current = 'Delivering food to customers';
      
        setState(() {});
      }else{
        print(res.body);
      Future.delayed(Duration(seconds: 2)).then((value) => {
            pr.hide().whenComplete(() => {print(pr.isShowing())})
          });}
    }).catchError((err) {
      print(err);
    });
  }

  _onCompleteDeliver() {}

  void _showSuccessPick() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('You have picked the food'),
              content: Text('Next, deliver food to your customer'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                MaterialButton(
                    child: Text('Ok'),
                    onPressed: () => {Navigator.of(context).pop()})
              ],
            ));
            
  }
}
