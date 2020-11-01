import 'package:flutter/material.dart';
import 'package:fypv1/order.dart';
import 'package:fypv1/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:fypv1/main.dart';

final double delivercharge = 1.5;

class OrderDetail extends StatefulWidget {
  final Order order;
  final User user;

  OrderDetail({Key key, this.order, this.user}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  double screenHeight, screenWidth;
  String server = "http://lawlietaini.com/hewdeliver";
  bool _isVisible = false;

  TextEditingController _reason = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print('order detail');
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                height: screenHeight / 2,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Icon(
                      Icons.notifications_on_outlined,
                      color: Colors.blueAccent,
                      size: 30,
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
                              "Food Quantity: ",
                              style: TextStyle(fontSize: 18),
                            )),
                            TableCell(
                                child: Text(
                              "${widget.order.quantity}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ))
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              "Food Name: ",
                              style: TextStyle(fontSize: 18),
                            )),
                            TableCell(
                                child: Text(
                              "${widget.order.ordername}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ))
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              "Total Price: ",
                              style: TextStyle(fontSize: 18),
                            )),
                            TableCell(
                                child: Text(
                              "RM ${widget.order.total}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ))
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              "Status: ",
                              style: TextStyle(fontSize: 18),
                            )),
                            TableCell(
                                child: Text(
                              "${widget.order.method}" == null
                                  ? "COD"
                                  : "Credit",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ))
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text('Confirm Accept Order'),
                                          content: Text(
                                              'Do you want accept the order?'),
                                          actions: [
                                            MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    _onAccepetOrder();
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MainScreen(
                                                                          user:
                                                                              widget.user,
                                                                        )),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  });
                                                },
                                                child: Text('Yes')),
                                            MaterialButton(
                                              onPressed: () => {
                                                Navigator.of(context).pop(false)
                                              },
                                              child: Text('No'),
                                            )
                                          ],
                                        ));
                              },
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: MaterialButton(
                              color: Colors.redAccent,
                              onPressed: () => {_onRejectOrder()},
                              child: Text("Reject",
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Visibility(
                        visible: _isVisible,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    labelText:
                                        'State your reject reasons here. '),
                              ),
                              SizedBox(height: 5),
                              RaisedButton(
                                  elevation: 5,
                                  color: Colors.white,
                                  onPressed: () async {
                                    await http.post(
                                        server + "/php/reject_order.php",
                                        body: {
                                          'reason': _reason.text,
                                          'orderid': widget.order.orderid,
                                          'foodid': widget.order.orderfood
                                        }).then((res) {
                                      if (res.body == 'success') {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                      'Successfully rejected'),
                                                  actions: [
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text('Ok'),
                                                    )
                                                  ],
                                                ));
                                        _isVisible = false;
                                        setState(() {});
                                      } else {
                                        print(res.body);
                                      }
                                    }).catchError((err) {
                                      print(err);
                                    });
                                  },
                                  child: Text('Submmit'))
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onAccepetOrder() async {
    ProgressDialog pr = ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    pr.style(message: 'Loading');
    pr.show();
    if (widget.user.phone == null || int.parse(widget.user.phone) < 6) {
      Toast.show('You must have a valid phone', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
    await http.post(server + "/php/accept_order.php", body: {
      'orderid': widget.order.orderid,
      'email': widget.user.email,
      'foodid': widget.order.orderfood,
      'phone': widget.user.phone,
      'method': widget.order.method,
      'total': widget.order.price,
     
    }).then((res) {
      print(res.body);
      if (res.body == 'fail') {
        Toast.show('error', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
            _showSuccess();
          });
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onRejectOrder() {
    http.post(server + "/php/reject_order.php", body: {
      'orderid': widget.order.orderid,
      'email': widget.user.email,
      'foodid': widget.order.orderfood,
    }).then((res) {
      print(res.body);
    }).catchError((err) {
      print(err);
    });
    _isVisible = true;
    setState(() {});
  }

  void _loadOrder() {}

  void _showSuccess()async {
    print('enter success');
   await showDialog(
        context: context,
        builder: (BuildContext context) {
         return CupertinoAlertDialog(
            title: const Text('Accepted successfully'),
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
  }
}
