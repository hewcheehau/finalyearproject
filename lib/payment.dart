import 'dart:ffi';
import 'creditinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'user.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';
import 'package:fypv1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

var uuid = Uuid();
var dateformat = new DateFormat('yyyy-MM-dd');
var now = new DateTime.now();
String formattedDate = dateformat.format(now);

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val, methodpay, tokenowner, address;

  const PaymentScreen(
      {Key key,
      this.user,
      this.orderid,
      this.val,
      this.methodpay,
      this.tokenowner,
      this.address})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String server = "http://lawlietaini.com/hewdeliver";
  double _progress = 0;
  int _paid = 0;
  String userPhone = "";
  String _bill;
  Timer timer;
  int _counter = 0;
  String _ispaid;
  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => reloadResponse());
    super.initState();
    userPhone = widget.user.phone.toString().substring(1);
    print('userphone is ' + userPhone);
    _bill = uuid.v1();
    //  _loadRespond();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backToPreviousPage,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(icon: Icon(Icons.backspace_outlined),onPressed: _backToPreviousPage,),
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
                        child: Column(
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
                                defaultColumnWidth: FlexColumnWidth(1.0),
                                columnWidths: {
                                  0: FlexColumnWidth(3.5),
                                  1: FlexColumnWidth(6.5)
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Order id',
                                      ),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${widget.orderid}'),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Bill id'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_bill),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Email to'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${widget.user.email}'),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Amount to pay'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('RM ${widget.val}'),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Payment Status'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Unpaid'),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Delivery option'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${widget.methodpay}"),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Date'),
                                    )),
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(formattedDate.toString()),
                                    ))
                                  ])
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          /*   _progress == 1
                                      ? Container(
                                          child: Column(
                                            children: [
                                              CircularProgressIndicator(
                                                value: 5,
                                              ),
                                              SizedBox(height: 5),
                                              Text('Please wait a moment'),
                                            ],
                                          ),
                                        )
                                      :*/
                          Container(),
                          SizedBox(height: 15),
                          MaterialButton(
                            onPressed: () {
                              _getQue();

                              _updatepayment();
                              setState(() {});
                            },
                            child: Text(
                              'Confirm',
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
    http.post(server + "/php/update_cod.php", body: {
      'email': widget.user.email,
      'amount': widget.val,
      'orderid': widget.orderid,
      'billid': _bill,
      'name': widget.user.name,
      'mobile': widget.user.phone,
      'address': widget.address,
      'method': widget.methodpay
    }).then((res) {
      print(res.body);
      if (res.body == 'payment fail') {
        _paid = 0;

        setState(() {});
      } else {
        _paid = 1;
        setState(() {});
      }
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
    print('onbackpress payment');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlgetuser = "http://lawlietaini.com/hewdeliver/php/get_user.php";
    
    http.post(urlgetuser, body: {
      "email": widget.user.email,
      'password': prefs.get('pass').toString()
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == 'success') {
        User updateuser = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            type: dres[4],
            credit: dres[5],
            datereg: dres[6],
            address: dres[7],
            token: dres[8]);
            widget.user.credit = dres[5];
            
       Navigator.pop(context);

      /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreditInfo(
                      user: updateuser,
                    )));*/
                // Navigator.popUntil(context, (route) => false);
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }

  void _updatepayment() async {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    pr.style(message: "Updating payment...");
    pr.show();
    http.post(server + "/php/payment_cod.php", body: {
      'email': widget.user.email,
      'amount': widget.val,
      'orderid': widget.orderid,
      'billid': _bill,
      'name': widget.user.name,
      'mobile': widget.user.phone,
      'method': widget.methodpay,
      'address': widget.address
    }).then((res) {
      if (res.body == 'payment fail') {
        print('failed pay:' + res.body);
      } else {
        print('order added');
        _showResult();
      }
      Future.delayed(Duration(seconds: 2)).then((value) {
        pr.hide().whenComplete(() => {print(pr.isShowing())});
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<Void> _showResult() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('payfood', 1);
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Ordered successful.'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text("Please allow time to seller to decide the order,"),
              actions: [
                MaterialButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(user: widget.user)));
                    })
              ],
            ));
  }
}
