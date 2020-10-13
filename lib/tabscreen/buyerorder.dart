import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class BuyerOrderScreen extends StatefulWidget {
  final User user;

  BuyerOrderScreen({Key key,this.user}):super(key: key);
  
  @override
  _BuyerOrderScreenState createState() => _BuyerOrderScreenState();
}

class _BuyerOrderScreenState extends State<BuyerOrderScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String server = "http://lawlietaini.com/hewdeliver";
  List itemorder;
  String titlecenter = "Loading order...";

  @override
  void initState(){
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadOrder();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('OrderDetail',style: TextStyle(color:Colors.black),),
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
                  itemorder==null?Flexible(
                                      child: Container(
                      child: Align(
                        alignment: Alignment.center,
                                              child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Load again',
                              icon: Icon(Icons.refresh), onPressed: ()=>{_loadOrder()}),
                            Text(titlecenter),
                          ],
                        ),
                      ),
                    ),
                  ):Expanded(
                   
                    child: ListView.builder(
                    itemCount: itemorder.length,
                    itemBuilder: (context,index){
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height:12.0),
                            Text('#Order id: ${itemorder[index]['id']}',style: TextStyle(fontWeight:FontWeight.bold),),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration:BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("asset/images/order.png")
                                )
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text('Your order view',style: TextStyle(letterSpacing: 0.7),)),
                            ),
                            Container(
                              height: 500,
                              width: double.infinity,
                             
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  children: [

                                    itemorder[index]['status']==null?Flexible(child: Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(5.0),
                                        child:IconButton(icon: Icon(Icons.refresh),onPressed: ()=>{_loadOrder()},)),
                                        Text('Your order under pending...',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
                                      ],
                                    ),):Expanded(child: Container(
                                      child: Column(children: [
                                        Text('Order delivering info: '),
                                        SizedBox(height:12.0),
                                        itemorder[index]['status'] == "rejected"?Flexible(
                                                                                  child: Column(
                                            children: [
                                              
                                              Icon(Icons.mood_bad,size: 39,),
                                              
                                              Text('Your order had been rejected by seller.',style: TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 18),),
                                              SizedBox(height:8.0),
                                              Text("Click below 'Ok' to start another new order."),
                                              SizedBox(height:8.0),
                                              MaterialButton(onPressed: (){},child:Text('Ok',style: TextStyle(color:Colors.white),),color: Colors.blueAccent,)
                                            ],
                                          ),
                                        ):Expanded(child: Column(children: [

                                        ],))

                                      ],)

                                    ))
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
    
      void _loadOrder() async{
          ProgressDialog pr = new ProgressDialog(context,isDismissible: true,type: ProgressDialogType.Normal);

          pr.style(message:"Loading your order...");
          pr.show();
          http.post(server+"/php/load_buyerorder.php",body:{
            'email' : widget.user.email,
            
          }).then((res){
            print(res.body);
            if(res.body == "Order empty"){
                Toast.show(res.body, context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                itemorder = null;
                titlecenter = "No order found";
                Future.delayed(Duration(seconds: 2)).then((value) {
                  pr.hide().whenComplete(() {
                    print(pr.isShowing());
                  });
                });
                setState(() {
                  
                });
            }else{
                Future.delayed(Duration(seconds: 2)).then((value) {
                  pr.hide().whenComplete(() {
                    print(pr.isShowing());
                  });
                });
              var extraction = json.decode(res.body);
              itemorder = extraction["order"];
                setState(() {
                  
                });
            }
          } );
      }
    Future<Null> get refreshList async {
    await Future.delayed(Duration(seconds: 2));
    _loadOrder();
    return null;
  }
}