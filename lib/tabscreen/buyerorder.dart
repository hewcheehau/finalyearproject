import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:fypv1/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BuyerOrderScreen extends StatefulWidget {
  final User user;

  BuyerOrderScreen({Key key, this.user}) : super(key: key);

  @override
  _BuyerOrderScreenState createState() => _BuyerOrderScreenState();
}

class _BuyerOrderScreenState extends State<BuyerOrderScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String server = "http://lawlietaini.com/hewdeliver";
  List itemorder, itemraider;
  String titlecenter = "Loading order...";
  Timer timer, timer2;
  double screenHeight, screenWidth;
  String _timeline = "wait";
  String _orderid;
  String _current;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this._loadOrder();
    timer = new Timer.periodic(Duration(seconds: 5),
        (Timer t) => _current == 'Order empty' ? print('wait') : loadValue());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void loadValue() {
    try {
      http.post(server + "/php/load_buyerdeliver.php",
          body: {'email': widget.user.email, 'orderid': _orderid}).then((res) {
        print(res.body);
        if (res.body == 'failed') {
          itemraider = null;

          setState(() {});
        } else {
          var extraction = json.decode(res.body);
          itemraider = extraction["raider"];
          _timeline = itemraider[0]['status'];
          timer.cancel();
          _checkTimeline();
          setState(() {});
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'OrderDetail',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList;
          },
          child: Column(
            children: [
              itemorder == null
                  ? Flexible(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  tooltip: 'Load again',
                                  icon: Icon(Icons.refresh),
                                  onPressed: () => {_loadOrder()}),
                              Text(titlecenter),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: itemorder.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12.0),
                                  Text(
                                    '#Order id: ${itemorder[index]['id']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  /*  Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.contain,
                                                              image: AssetImage(
                                                                  "asset/images/order.png")))),*/
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Your order view',
                                          style: TextStyle(letterSpacing: 0.7),
                                        )),
                                  ),
                                  Container(
                                    height: screenHeight / 1.0,
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          itemorder[index]['status'] == null
                                              ? Flexible(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.0),
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.refresh),
                                                            onPressed: () =>
                                                                {_loadOrder()},
                                                          )),
                                                      Text(
                                                        'Your order under pending...',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Container(
                                                      child: Column(
                                                  children: [
                                                    Text(
                                                        'Order delivering info: '),
                                                    SizedBox(height: 12.0),
                                                    itemorder[index]
                                                                ['status'] ==
                                                            "rejected"
                                                        ? Flexible(
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .mood_bad,
                                                                  size: 39,
                                                                ),
                                                                Text(
                                                                  'Your order had been rejected by seller.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                    "Click below 'Ok' to start another new order."),
                                                                SizedBox(
                                                                    height:
                                                                        8.0),
                                                                MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    http.post(
                                                                        server +
                                                                            "/php/update_buyerorder.php",
                                                                        body: {
                                                                          'email': widget
                                                                              .user
                                                                              .email
                                                                        }).then(
                                                                        (res) {
                                                                      print(res
                                                                          .body);
                                                                      if (res.body ==
                                                                          'success') {
                                                                        _loadOrder();
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        Toast.show(
                                                                            'error',
                                                                            context,
                                                                            duration:
                                                                                Toast.LENGTH_LONG,
                                                                            gravity: Toast.BOTTOM);
                                                                      }
                                                                    }).catchError(
                                                                        (err) {
                                                                      print(
                                                                          err);
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    'Ok',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  color: Colors
                                                                      .blueAccent,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: itemraider ==
                                                                    null
                                                                ? Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                            'Getting transpoter infor...'),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Table(
                                                                            defaultColumnWidth:
                                                                                FlexColumnWidth(1.0),
                                                                            columnWidths: {
                                                                              0: FlexColumnWidth(3.5),
                                                                              1: FlexColumnWidth(6.5)
                                                                            },
                                                                            children: [
                                                                              TableRow(children: [
                                                                                TableCell(child: Text('Transporter name: ')),
                                                                                TableCell(
                                                                                    child: Text(
                                                                                  "${itemraider[index]['name']},",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ))
                                                                              ]),
                                                                              TableRow(children: [
                                                                                TableCell(child: Text('Transporter phone: ')),
                                                                                TableCell(child: Text("${itemraider[index]['phone']}", style: TextStyle(fontWeight: FontWeight.bold)))
                                                                              ]),
                                                                              TableRow(children: [
                                                                                TableCell(child: Text('Status: ')),
                                                                                TableCell(child: Text("${itemraider[index]['status']}", style: TextStyle(fontWeight: FontWeight.bold)))
                                                                              ])
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                8.0),
                                                                      ],
                                                                    ),
                                                                  )),
                                                  ],
                                                ))),
                                          Expanded(
                                            flex: 6,
                                            child: Card(
                                              //  color: Colors.blue,
                                              elevation: 5,
                                              child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  height: screenHeight / 1.2,
                                                  width: screenWidth / 1.0,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Information',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Expanded(
                                                        child: TimelineTile(
                                                          axis: TimelineAxis
                                                              .vertical,
                                                          alignment:
                                                              TimelineAlign
                                                                  .start,
                                                          isFirst: true,
                                                          endChild: Row(
                                                            children: [
                                                              Image.asset(
                                                                'asset/images/orderplace.png',
                                                                scale: 12,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    'Order Placed',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      'Waiting seller to accept.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          indicatorStyle:
                                                              IndicatorStyle(
                                                            height: 50,
                                                            width: 30,
                                                            color: _timeline ==
                                                                    'wait'
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,

                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),

                                                            // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TimelineTile(
                                                          axis: TimelineAxis
                                                              .vertical,
                                                          alignment:
                                                              TimelineAlign
                                                                  .start,
                                                          endChild: Row(
                                                            children: [
                                                              Image.asset(
                                                                'asset/images/orderconfirm.png',
                                                                scale: 12,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    'Order Confirmed',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      'Your order has been approved.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          indicatorStyle:
                                                              IndicatorStyle(
                                                            height: 40,
                                                            width: 30,
                                                            color: _timeline ==
                                                                    'accepted'
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,

                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),

                                                            // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TimelineTile(
                                                          axis: TimelineAxis
                                                              .vertical,
                                                          alignment:
                                                              TimelineAlign
                                                                  .start,
                                                          endChild: Row(
                                                            children: [
                                                              Image.asset(
                                                                'asset/images/orderprocessed.png',
                                                                scale: 12,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    'Order Processed',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      'Assigning a transporter to deliver.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          indicatorStyle:
                                                              IndicatorStyle(
                                                            height: 40,
                                                            width: 30,
                                                            color: _timeline ==
                                                                    'pick'
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,

                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),

                                                            // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TimelineTile(
                                                          axis: TimelineAxis
                                                              .vertical,
                                                          alignment:
                                                              TimelineAlign
                                                                  .start,
                                                          endChild: Row(
                                                            children: [
                                                              Image.asset(
                                                                'asset/images/pickup.png',
                                                                scale: 12,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    'Ready to Pick up',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      'Transpoter picked up food from seller.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          indicatorStyle:
                                                              IndicatorStyle(
                                                            height: 40,
                                                            width: 30,
                                                            color: _timeline ==
                                                                    'deliver'
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,

                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),

                                                            // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TimelineTile(
                                                          axis: TimelineAxis
                                                              .vertical,
                                                          alignment:
                                                              TimelineAlign
                                                                  .start,
                                                          endChild: Row(
                                                            children: [
                                                              Image.asset(
                                                                'asset/images/check.png',
                                                                scale: 12,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    'Order Completed',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      'Food has been successfully delivered.',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          indicatorStyle:
                                                              IndicatorStyle(
                                                            height: 40,
                                                            width: 30,
                                                            color: _timeline ==
                                                                    'reach'
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,

                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),

                                                            // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          )

                                          //try
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(border: Border(top: BorderSide())),
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                              minWidth: double.maxFinite,
                              onPressed: () async {
                                String order = itemorder[0]['id'];

                                if (itemorder.isEmpty && itemraider.isEmpty) {
                                  Toast.show('No order', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  return;
                                }
                                if(itemraider.isEmpty){
                                   Toast.show('No transpoter assign', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  return;
                                }
                                print('haha');
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text('Are you sure?'),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          content: Text(
                                              'Have you received your food?'),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () async {
                                                _goToReceiveOrder(order);
                                              },
                                              child:
                                                  Text('Yes, I have received.'),
                                            ),
                                            MaterialButton(
                                              onPressed: () => {
                                                Navigator.of(context).pop(false)
                                              },
                                              child: Text('No.'),
                                            )
                                          ],
                                        ));
                              },
                              child: Container(
                                child: Text(
                                  'Order Received',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              color: itemorder == null
                                  ? Colors.grey
                                  : Colors.lightBlue),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadOrder() async {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);

    pr.style(message: "Loading your order...");
    pr.show();
    http.post(server + "/php/load_buyerorder.php", body: {
      'email': widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "Order empty") {
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        itemorder = null;
        titlecenter = "No order found";
        _current = "Order empty";
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
        setState(() {});
      } else {
        print('got order');
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
        var extraction = json.decode(res.body);
        itemorder = extraction["order"];

        _checkTimeline();
        setState(() {});
      }
    });
  }

  Future<Null> get refreshList async {
    await Future.delayed(Duration(seconds: 2));
    _loadOrder();
    return null;
  }

  Future<Null> _checkTimeline() async {
    print('enter checktime');
    List itemd;
    if (itemraider == null) {
      itemd = itemorder;
      _timeline = itemd[0]['status'];
      if (_timeline == null) {
        _timeline = "wait";
      }
      print(itemd);
    } else {
      itemd = itemraider;
      _timeline = itemd[0]['status'];
    }
    _orderid = itemd[0]['id'];
  }

  void _goToReceiveOrder(String o) async {
    
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    pr.style(message: 'Please wait...');
    pr.show();
    Future.delayed(Duration(milliseconds: 2)).then((value) => {
          pr.hide().whenComplete(() => {print(pr.isShowing())})
        });
    await http.post(server + "/php/update_receivefood.php",
        body: {'email': widget.user.email, 'orderid': o}).then((res) {
      if (res.body == 'success') {
        Toast.show('Completed successfully', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RateScreen(
                      user: widget.user,
                      orderid: _orderid,
                    ))).then((value) => setState(() {}));
        setState(() {});
      } else {
        print(res.body);

        Toast.show('fail', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }
}

class RateScreen extends StatefulWidget {
  final User user;
  final String orderid;

  RateScreen({Key key, this.user, this.orderid}) : super(key: key);
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _goBackPage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Rate Product',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: Colors.grey,
            ),
            onPressed: () => {Navigator.of(context).pop(false)},
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please rate food quality: "),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          unratedColor: Colors.grey[300],
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            print(rating);
                            _rating = rating;
                          },
                        ),
                        Text('Is food quality good?')
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                    color: Colors.blue[700],
                    onPressed: () {
                      if (_rating == 0) {
                        Toast.show('Please rate', context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      }
                      String rating = _rating.toString();
                      http.post(
                          "http://lawlietaini.com/hewdeliver/php/rate_food.php",
                          body: {
                            'email': widget.user.email,
                            'rate': rating,
                            'orderid': widget.orderid
                          }).then((res) {
                        if (res.body == 'nodata') {
                          Toast.show('error', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else {
                          Toast.show('success', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Text(
                      'Submmit',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _goBackPage() async {
    return await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Align(
                      alignment: Alignment.center,
                      child: Text('Are you sure?')),
                  content: Text('Are you want to back without rating food?'),
                  actions: [
                    MaterialButton(
                      onPressed: () => {Navigator.of(context).pop(true)},
                      child: Text('Yes'),
                    ),
                    MaterialButton(
                      onPressed: () => {Navigator.of(context).pop(false)},
                      child: Text('No'),
                    ),
                  ],
                )) ??
        false;
  }
}
