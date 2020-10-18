import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:timeline_tile/timeline_tile.dart';

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
  Timer timer,timer2;
  double screenHeight, screenWidth;
  String _timeline = "wait";
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadOrder();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => loadValue());
  
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void loadValue() {
    print('enter');
    http.post(server + "/php/load_buyerdeliver.php",
        body: {'email': widget.user.email}).then((res) {
      print(res.body);
      if (res.body == 'failed') {
        setState(() {
          itemraider = null;
        });
      } else {
        var extraction = json.decode(res.body);
        itemraider = extraction["raider"];
        _checkTimeline();
                        timer.cancel();
                        setState(() {});
                      }
                    });
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
                                                                                                TableCell(child: Text("${itemraider[index]['status']}-ing", style: TextStyle(fontWeight: FontWeight.bold)))
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
                                                                            padding:
                                                                                EdgeInsets.all(
                                                                                    5.0),
                                                                            height:
                                                                                screenHeight /
                                                                                    1.2,
                                                                            width: screenWidth /
                                                                                1.0,
                                                                            child: Column(
                                                                              mainAxisSize:
                                                                                  MainAxisSize
                                                                                      .min,
                                                                              children: [
                                                                                Text(
                                                                                  'Information',
                                                                                  style: TextStyle(
                                                                                      fontWeight:
                                                                                          FontWeight
                                                                                              .bold),
                                                                                ),
                                                                                SizedBox(
                                                                                    height:
                                                                                        8.0),
                                                                                Expanded(
                                                                                  child:
                                                                                      TimelineTile(
                                                                                    axis: TimelineAxis
                                                                                        .vertical,
                                                                                    alignment:
                                                                                        TimelineAlign
                                                                                            .start,
                                                                                    isFirst:
                                                                                        true,
                                                                                         
                                                                                    endChild:
                                                                                        Row(
                                                                                      children: [
                                                                                        Image
                                                                                            .asset(
                                                                                          'asset/images/orderplace.png',
                                                                                          scale:
                                                                                              12,
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisSize:
                                                                                              MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Order Placed',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text('Waiting seller to accept.',
                                                                                                style: TextStyle(fontSize: 13)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    indicatorStyle:
                                                                                        IndicatorStyle(
                                                                                      height:
                                                                                          50,
                                                                                      width: 30,
                                                                                      color: _timeline=='wait'?Colors.blueAccent:Colors.grey,
                                                                                      
                                                                                    
                
                                                                                      padding:
                                                                                          EdgeInsets.all(
                                                                                              8.0),
                
                                                                                      // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child:
                                                                                      TimelineTile(
                                                                                    axis: TimelineAxis
                                                                                        .vertical,
                                                                                    alignment:
                                                                                        TimelineAlign
                                                                                            .start,
                                                                                    endChild:
                                                                                        Row(
                                                                                      children: [
                                                                                        Image
                                                                                            .asset(
                                                                                          'asset/images/orderconfirm.png',
                                                                                          scale:
                                                                                              12,
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisSize:
                                                                                              MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Order Confirmed',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text('Your order has been approved.',
                                                                                                style: TextStyle(fontSize: 13)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    indicatorStyle:
                                                                                        IndicatorStyle(
                                                                                      height:
                                                                                          40,
                                                                                      width: 30,
                                                                                      color: _timeline=='confirm'?Colors.blueAccent:Colors.grey,
                
                                                                                        
                
                                                                                      padding:
                                                                                          EdgeInsets.all(
                                                                                              8.0),
                
                                                                                      // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child:
                                                                                      TimelineTile(
                                                                                    axis: TimelineAxis
                                                                                        .vertical,
                                                                                    alignment:
                                                                                        TimelineAlign
                                                                                            .start,
                                                                                    endChild:
                                                                                        Row(
                                                                                      children: [
                                                                                        Image
                                                                                            .asset(
                                                                                          'asset/images/orderprocessed.png',
                                                                                          scale:
                                                                                              12,
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisSize:
                                                                                              MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Order Processed',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text('Assigning a transporter to deliver.',
                                                                                                style: TextStyle(fontSize: 13)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    indicatorStyle:
                                                                                        IndicatorStyle(
                                                                                      height:
                                                                                          40,
                                                                                      width: 30,
                                                                                      color: _timeline=='pick'?Colors.blueAccent:Colors.grey,
                
                                                                                      padding:
                                                                                          EdgeInsets.all(
                                                                                              8.0),
                
                                                                                      // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child:
                                                                                      TimelineTile(
                                                                                    axis: TimelineAxis
                                                                                        .vertical,
                                                                                    alignment:
                                                                                        TimelineAlign
                                                                                            .start,
                                                                                    endChild:
                                                                                        Row(
                                                                                      children: [
                                                                                        Image
                                                                                            .asset(
                                                                                          'asset/images/pickup.png',
                                                                                          scale:
                                                                                              12,
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisSize:
                                                                                              MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Ready to Pick up',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text('Transpoter picked up food from seller.',
                                                                                                style: TextStyle(fontSize: 13)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    indicatorStyle:
                                                                                        IndicatorStyle(
                                                                                      height:
                                                                                          40,
                                                                                      width: 30,
                                                                                      color: _timeline=='deliver'?Colors.blueAccent:Colors.grey,
                
                                                                                      padding:
                                                                                          EdgeInsets.all(
                                                                                              8.0),
                
                                                                                      // iconStyle: IconStyle(iconData: Icons.fastfood_outlined,color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child:
                                                                                      TimelineTile(
                                                                                    axis: TimelineAxis
                                                                                        .vertical,
                                                                                    alignment:
                                                                                        TimelineAlign
                                                                                            .start,
                                                                                    endChild:
                                                                                        Row(
                                                                                      children: [
                                                                                        Image
                                                                                            .asset(
                                                                                          'asset/images/check.png',
                                                                                          scale:
                                                                                              12,
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisSize:
                                                                                              MainAxisSize.min,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Order Completed',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text('Food has been successfully delivered.',
                                                                                                style: TextStyle(fontSize: 13)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    indicatorStyle:
                                                                                        IndicatorStyle(
                                                                                      height:
                                                                                          40,
                                                                                      width: 30,
                                                                                      color: _timeline=='reach'?Colors.blueAccent:Colors.grey,
                
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
                                          }))
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
                         _checkTimeline();
                        Future.delayed(Duration(seconds: 2)).then((value) {
                          pr.hide().whenComplete(() {
                            print(pr.isShowing());
                          });
                        });
                        setState(() {});
                      } else {
                        _checkTimeline();
                        Future.delayed(Duration(seconds: 2)).then((value) {
                          pr.hide().whenComplete(() {
                            print(pr.isShowing());
                          });
                        });
                        var extraction = json.decode(res.body);
                        itemorder = extraction["order"];
                        setState(() {});
                      }
                      
                    });
                  }
                
                  Future<Null> get refreshList async {
                    await Future.delayed(Duration(seconds: 2));
                    _loadOrder();
                    return null;
                  }
        
          void _checkTimeline() {
            if(itemraider[0]['status']==null){
              _timeline = 'wait';
            }else{
            _timeline = itemraider[0]['status'];
            }
          }
        
          
}
