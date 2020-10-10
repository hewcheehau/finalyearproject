import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'user.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';

var uuid = Uuid();
var dateformat = new DateFormat('yyyy-MM-dd');
var now = new DateTime.now();
String formattedDate = dateformat.format(now);

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val, methodpay, tokenowner;

  const PaymentScreen(
      {Key key,
      this.user,
      this.orderid,
      this.val,
      this.methodpay,
      this.tokenowner})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String server = "http://lawlietaini.com/hewdeliver";
  double _progress = 0;
  int _paid;
  String userPhone = "";
  String _bill;

  @override
  void initState() {
    super.initState();
    userPhone = widget.user.phone.toString().substring(1);
    print('userphone is ' + userPhone);

    _loadRespond();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backToPreviousPage,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                widget.methodpay == 'DCP'
                    ? Expanded(
                        child: WebView(
                          initialUrl:
                              'http://lawlietaini.com/hewdeliver/php/make_payment.php?email=' +
                                  widget.user.email +
                                  '&mobile=' +
                                  widget.user.phone +
                                  '&name=' +
                                  widget.user.name +
                                  '&amount=' +
                                  widget.val +
                                  '&orderid=' +
                                  widget
                                      .orderid, //"http://lawlietaini.com/hewdeliver/php/payments.php?email="+widget.user.email+'&mobile='+widget.user.phone+'&name='+widget.user.name+'&amount='+widget.val+'&orderid='+widget.orderid,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                        ),
                      )
                    : Container(
                        child: _paid == null
                            ? Column(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Please wait a moment...'),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'Cash on delivery payment',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Container(
                                      child: Table(
                                        border: TableBorder.all(),
                                        defaultColumnWidth:
                                            FlexColumnWidth(1.0),
                                        columnWidths: {
                                          0: FlexColumnWidth(3.5),
                                          1: FlexColumnWidth(6.5)
                                        },
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Order id',
                                              ),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('${widget.orderid}'),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Bill id'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(_bill),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Email to'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text('${widget.user.email}'),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Amount to pay'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('RM ${widget.val}'),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Payment Status'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Unpaid'),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Delivery option'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text("${widget.methodpay}"),
                                            ))
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Date'),
                                            )),
                                            TableCell(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  formattedDate.toString()),
                                            ))
                                          ])
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  _progress == 1
                                      ? Container(
                                          child: Column(
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 5),
                                              Text('Please wait a moment'),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(height: 15),
                                  MaterialButton(
                                    onPressed: () {
                                      if (_progress == 0) {
                                        _getQue();
                                      }
                                      _progress = 1;
                                      _updatepayment();
                                                                            setState(() {});
                                                                          },
                                                                          child: Text(
                                                                            _progress == 0 ? 'Proceed' : 'Pending...',
                                                                            style: TextStyle(color: Colors.white),
                                                                          ),
                                                                          color: Colors.blueAccent,
                                                                        )
                                                                      ],
                                                                    ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      
                                        void _loadRespond() async {
                                          _bill = uuid.v1();
                                          http.post(server + "/php/payment_cod.php", body: {
                                            'email': widget.user.email,
                                            'amount': widget.val,
                                            'orderid': widget.orderid,
                                            'billid': _bill,
                                            'name': widget.user.name,
                                            'mobile': widget.user.phone
                                          }).then((res) {
                                            print(res.body);
                                            if (res.body == 'success') {
                                              _paid = 1;
                                      
                                              setState(() {});
                                            } else {}
                                          }).catchError((err) {
                                            print(err);
                                          });
                                        }
                                      
                                        Future _getQue() async {
                                          print('enter ' + widget.tokenowner);
                                          if (widget.tokenowner != null) {
                                            var response = await http
                                                .post(server + "/php/notify.php", body: {"token": widget.tokenowner});
                                            print('success');
                                            return json.decode(response.body);
                                          } else {
                                            print("Token is null");
                                          }
                                        }
                                      
                                        Future<bool> _backToPreviousPage() async {
                                          return await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                        title: Text('Are you sure?'),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)),
                                                        content: Text('You have not yet to complete your order'),
                                                        actions: [
                                                          MaterialButton(
                                                              child: Text('Back'),
                                                              onPressed: () {
                                                                http.post(server + "/php/cancel_order.php", body: {
                                                                  'email': widget.user.email,
                                                                  'orderid': widget.orderid,
                                                                  
                                                                }).then((res) {
                                                                  print(res.body);
                                                                  if (res.body == 'success') {
                                                                    return Future.value(true);
                                                                  } else {
                                                                    print('fail cancel');
                                                                  }
                                                                }).catchError((err) {
                                                                  print(err);
                                                                });
                                                                Navigator.of(context).pop(true);
                                                              }),
                                                          MaterialButton(
                                                              child: Text('No'),
                                                              onPressed: () => {Navigator.of(context).pop(false)})
                                                        ],
                                                      )) ??
                                              false;
                                        }
                                      
                                        void _updatepayment() async{
                                          http.post(server+"/php/update_cod.php",body: {
                                            'email': widget.user.email,
                                            'amount': widget.val,
                                            'orderid': widget.orderid,
                                            'billid': _bill,
                                            'name': widget.user.name,
                                            'mobile': widget.user.phone,
                                            'method':widget.methodpay,
                                          }).then((res){
                                            if(res.body=='success'){
                                              print('order added');
                                            }else{
                                              print('failed pay:'+res.body);
                                            }
                                          } ).catchError((err){
                                            print(err);
                                          });
                                        }
}
