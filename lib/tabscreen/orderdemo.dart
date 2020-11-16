import 'package:flutter/material.dart';
import 'package:fypv1/order.dart';
import 'package:fypv1/order/ordercomplete.dart';
import 'package:fypv1/order/orderproceed.dart';
import 'dart:async';
import 'package:fypv1/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fypv1/order/orderdetail.dart';

int _counttoday, _countaccepted;

class OrderScreen extends StatefulWidget {
  final User user;

  OrderScreen({Key key, this.user}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List itemOrder;
  int current = 1;
  double sHeight, sWidth;
  String curItem = "Today";
  String server = "http://lawlietaini.com/hewdeliver";
  String titlecenter = "Load new order...";
  int _newOrder = 0;
  int _accepted = 0;
  int _history = 0;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadRespond();
  }

  @override
  Widget build(BuildContext context) {
    sHeight = MediaQuery.of(context).size.height;
    sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Order Receive',
          style: TextStyle(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: Container(
          child: Column(
            children: [
              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          FlatButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.white,
                              onPressed: () => {_sortOrder("Today")},
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18.0),
                              )),
                        ],
                      ),
                      SizedBox(width: 12.0),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey),
                          ),
                          color: Colors.white,
                          onPressed: () => {_sortOrder("Accepted")},
                          child: Text(
                            'Accepted',
                            style: TextStyle(
                                color: Colors.greenAccent[700], fontSize: 18.0),
                          )),
                      SizedBox(width: 12.0),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey),
                          ),
                          color: Colors.white,
                          onPressed: () => {_sortOrder("History")},
                          child: Text(
                            'History',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 18.0),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      curItem + " Order ",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: Text(
                      "",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Divider(),
                  itemOrder == null
                      ? Flexible(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton.icon(
                                onPressed: () => {_loadRespond()},
                                icon: Icon(Icons.refresh_outlined),
                                label: Text(titlecenter))
                          ],
                        ))
                      : Expanded(
                          child: RefreshIndicator(
                          key: refreshKey,
                          onRefresh: refreshList,
                          child: ListView.builder(
                              itemCount: itemOrder.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () => {
                                              itemOrder[index]['status'] ==
                                                      'proceed'
                                                  ? _onOrderProceed(
                                                      itemOrder[index]
                                                          ['foodid'],
                                                      itemOrder[index]
                                                          ['foodname'],
                                                      itemOrder[index]['price'],
                                                      itemOrder[index]
                                                          ['foodtime'],
                                                      itemOrder[index]
                                                          ['foodimage'],
                                                      itemOrder[index]
                                                          ['quantity'],
                                                      itemOrder[index]
                                                          ['method'],
                                                      itemOrder[index]
                                                          ['orderid'],
                                                      itemOrder[index]['total']
                                                          .toString())
                                                  : _onOrderDetail(
                                                      itemOrder[index]
                                                          ['foodid'],
                                                      itemOrder[index]
                                                          ['foodname'],
                                                      itemOrder[index]['price'],
                                                      itemOrder[index]
                                                          ['foodtime'],
                                                      itemOrder[index]
                                                          ['foodimage'],
                                                      itemOrder[index]
                                                          ['quantity'],
                                                      itemOrder[index]
                                                          ['method'],
                                                      itemOrder[index]
                                                          ['orderid'],
                                                      itemOrder[index]['total']
                                                          .toString())
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "${itemOrder[index]['foodname']} - ${itemOrder[index]['quantity']}")),
                                                  Icon(Icons
                                                      .arrow_forward_ios_outlined)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.black87,
                                          )
                                        ],
                                      )),
                                );
                              }),
                        ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadRespond();
    return null;
  }

  _sortOrder(String type) async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          isDismissible: true, type: ProgressDialogType.Normal);
      pr.style(message: 'Loading...');
      pr.show();
      String urlLoadOrder = server + "/php/get_order.php";
      await http.post(urlLoadOrder, body: {
        'type': type,
        'email': widget.user.email,
      }).then((res) {
        if (res.body == 'noorder') {
          setState(() {
            itemOrder = null;
            curItem = type;
            titlecenter = "No order found";
          });
        } else {
          setState(() {
            curItem = type;
            var extraction = json.decode(res.body);
            itemOrder = extraction["order"];
            _countOrder();
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        }
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
      });
    } catch (e) {
      Toast.show('error', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadRespond() async {
    String _dDay = "Today";
    String urlLoadOrder = server + "/php/get_order.php";
    await http.post(urlLoadOrder, body: {
      'email': widget.user.email,
      'type': _dDay,
    }).then((res) {
      if (res.body == "noorder") {
        titlecenter = "No order";
        setState(() {
          itemOrder = null;
        });
      } else {
        print("got order");
        print(res.body);
        setState(() {
          var extractdata = json.decode(res.body);
          itemOrder = extractdata["order"];
        });
        _countOrder();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _countOrder() {
    String _curStore;
    
    _newOrder = itemOrder.length;
  }

  _onOrderDetail(itemOrder, itemOrder2, itemOrder3, itemOrder4, itemOrder5,
      itemOrder6, itemOrder7, itemOrder8, itemOrder9) {
        print("enter order detail ");
    Order order = new Order(
        orderfood: itemOrder,
        ordername: itemOrder2,
        price: itemOrder3,
        orderdate: itemOrder4,
        foodimage: itemOrder5,
        quantity: itemOrder6,
        method: itemOrder7,
        orderid: itemOrder8,
        total: itemOrder9);
   /* if(itemOrder['status']=='complete'){
      print("ok complte");
      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderComplete(order: order, user: widget.user)))
        .then((value) => onGoBack(value));
        return;
    }*/
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderDetail(order: order, user: widget.user)))
        .then((value) => onGoBack(value));
  }

  FutureOr onGoBack(dynamic value) {
    _loadRespond();
    setState(() {});
  }

  _onOrderProceed(itemOrder, itemOrder2, itemOrder3, itemOrder4, itemOrder5,
      itemOrder6, itemOrder7, itemOrder8, itemOrder9) {
    Order order = new Order(
        orderfood: itemOrder,
        ordername: itemOrder2,
        price: itemOrder3,
        orderdate: itemOrder4,
        foodimage: itemOrder5,
        quantity: itemOrder6,
        method: itemOrder7,
        orderid: itemOrder8,
        total: itemOrder9);

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderProceed(order: order, user: widget.user)))
        .then((value) => onGoBack(value));
  }
}
