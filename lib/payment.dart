import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'user.dart';
import 'dart:async';


class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val;

  const PaymentScreen({Key key, this.user,this.orderid,this.val}):super(key:key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController>_controller= Completer<WebViewController>();
  String server = "http://lawlietaini.com/hewdeliver";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: "http://lawlietaini.com/hewdeliver/php/payment.php?email="+widget.user.email+'&mobile='+widget.user.phone+'&name='+widget.user.name+'&amount='+widget.val+'&orderid='+widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ),
    );
  }
}