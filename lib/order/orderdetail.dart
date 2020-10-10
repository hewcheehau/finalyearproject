import 'package:flutter/material.dart';
import 'package:fypv1/order.dart';
import 'package:fypv1/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

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
        title: Text('Order detail'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height:8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                height: screenHeight / 2,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                    
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Icon(
                      Icons.alarm_add_outlined,
                      color: Colors.blueGrey,
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
                              "RM ${widget.order.price}",
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
                              "${widget.order.method}"==null?"COD":"Credit",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ))
                          ]),
                          
                          
                        ],

                      ),

                    ),
                    SizedBox(height:8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MaterialButton(
                          shape: Border.all(),
                          color: Colors.blueAccent,
                          onPressed: (){},child:Text("Accept",style: TextStyle(color:Colors.white),)),
                        SizedBox(width:5),
                        MaterialButton(
                          shape: Border.all(),
                          color: Colors.redAccent,
                          onPressed: (){},child:Text("Reject",style: TextStyle(color:Colors.white))),
                      ],
                    ),
                    SizedBox(height:8),
                    Visibility(
                      visible: false,
                      child: Container(
                        child: TextField(
                        
                    ),))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadOrder() {}
}
