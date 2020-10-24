import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:fypv1/deliver.dart';
import 'package:fypv1/order/deliverdetail.dart';

class TransporterScreen extends StatefulWidget {
  final User user;
  const TransporterScreen({Key key, this.user}) : super(key: key);

  @override
  _TransporterScreenState createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  String server = "http://lawlietaini.com/hewdeliver";
  String titlecenter = "Loading delivery order...";
  List itemdeliver;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      this._loadDeliver();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_outlined,
              color: Colors.blueAccent,
            ),
            onPressed: () => {_loadDeliver()},
            tooltip: 'Refresh',
          )
        ],
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text('Today Order',
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 12.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            itemdeliver == null
                ? Flexible(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () => {_loadDeliver()},
                        child: Icon(Icons.refresh),
                      ),
                      Text(
                        titlecenter,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ))
                : Expanded(
                    child: ListView.builder(
                        itemCount: itemdeliver.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () 
                                        => {
                                        _onDeliverDetail(
                                            itemdeliver[index]['orderid'],
                                            itemdeliver[index]['foodshop'],
                                            itemdeliver[index]['address'],
                                            itemdeliver[index]['method'],
                                            itemdeliver[index]['total'],
                                            itemdeliver[index]['date'],
                                            itemdeliver[index]['taskid'],
                                            itemdeliver[index]['custname'],
                                            itemdeliver[index]['custphone'],
                                            itemdeliver[index]['foodphone'],
                                            itemdeliver[index]['raider'],
                                            itemdeliver[index]['status'])
                                        
                                      },
                                      child: Column(
                                        children: [
                                          Text("${itemdeliver[index]['date']}"),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    Flexible(
                                                                                                      child: Text(
                                                        "${itemdeliver[index]['foodshop']}",
                                                        style:
                                                            TextStyle(fontSize: 16),
                                                      ),
                                                    ),
                                                    Icon(Icons.forward),
                                                    Expanded(
                                                                                                      child: Text(
                                                          "${itemdeliver[index]['address']}",
                                                          style:
                                                              TextStyle(fontSize: 16)),
                                                    )
                                                  ],
                                                )),
                                                Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black87,
                                    )
                                  ],
                                )),
                          );
                        }))
          ],
        ),
      ),
    );
  }

  Future<Null>_loadDeliver()async{
    print('enter transporter'); 
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    pr.style(message: 'Getting deliver order...');
    pr.show();

    http.post(server + "/php/get_delivery.php",
        body: {'email': widget.user.email,}).then((res) {
      print(res.body);
      if (res.body == 'nodeliver') {
        itemdeliver = null;
        titlecenter = "No order found";
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() => {print(pr.isShowing())});
        });
        setState(() {});
      } else {
        var extraction = json.decode(res.body);
        itemdeliver = extraction["deliver"];

        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() => {print(pr.isShowing())});
        });
        setState(() {});
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onDeliverDetail(itemdeliver, itemdeliver2, itemdeliver3, itemdeliver4, itemdeliver5,
      itemdeliver6, itemdeliver7,itemdeliver8,itemdeliver9,itemdeliver10,itemdeliver11,itemdeliver12) {
        
        Deliver deliver = new Deliver(  
          orderid: itemdeliver,
          foodshop: itemdeliver2,
          address: itemdeliver3,
          method: itemdeliver4,
          total: itemdeliver5,
          date: itemdeliver6,
          taskid: itemdeliver7,
          custname: itemdeliver8,
          custphone: itemdeliver9,
          foodphone: itemdeliver10,
          raider: itemdeliver11,
          status: itemdeliver12
        );
       Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliverDetail(deliver: deliver,user: widget.user,))).then((value)=>value?_getRequests():Null);
      }

       _getRequests()async{
         setState(() {
           
         });
       await _loadDeliver();
  }

}
