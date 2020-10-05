import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'user.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val, methodpay, tokenowner;

  const PaymentScreen({Key key, this.user,this.orderid,this.val,this.methodpay,this.tokenowner}):super(key:key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController>_controller= Completer<WebViewController>();
  String server = "http://lawlietaini.com/hewdeliver";
  double _progress = 0;
  int _paid = 0;
  String userPhone = "";

  @override 
  void initState(){
    super.initState();
    _getQue();
    userPhone = widget.user.phone.toString().substring(1);
    print('userphone is '+userPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               widget.methodpay=='DCP'? Expanded(
                  child: WebView(
                    initialUrl:  'http://lawlietaini.com/hewdeliver/php/make_payment.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone+
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&orderid=' +
                        widget.orderid,//"http://lawlietaini.com/hewdeliver/php/payments.php?email="+widget.user.email+'&mobile='+widget.user.phone+'&name='+widget.user.name+'&amount='+widget.val+'&orderid='+widget.orderid,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController){
                      _controller.complete(webViewController);
                    },
                  ),
                ):Container(
                    
                    child: _paid==0?Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                         
                        ),
                        SizedBox(height:15),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Please wait a moment...'),
                        )
                      ],
                    ):Column(
                     
                    )
                )
              ],
            ),
          ),
        ),
    );
  }

  void _loadRespond()async{

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

}