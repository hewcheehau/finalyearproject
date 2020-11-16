import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';


class DeliverFood extends StatefulWidget {
  final User user;

  DeliverFood({Key key, this.user}):super(key: key);
  
  @override
  _DeliverFoodState createState() => _DeliverFoodState();
}

class _DeliverFoodState extends State<DeliverFood> {
  String server = "http://lawlietaini.com/hewdeliver";
  double screenHeight, screenWidth;
  String titlecenter = "Loading...";
  List itemearn;

  @override
  void initState(){
    super.initState();
    this._loadEarn();
    print("enter earn");
      }
    
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('My Earn',style: TextStyle(letterSpacing: 0.7),),
          backgroundColor: Colors.blueAccent,),
    
          body: Center(
            child: Column(
              children: [
                itemearn==null?Flexible(child: Container(
                  alignment: Alignment.center,
                  child: Text(titlecenter,style: TextStyle(fontSize:20,color:Colors.grey),),)):Expanded(

                  child: ListView.builder(
                    itemCount: itemearn.length,
                    itemBuilder: (context,index){

                        return Container(
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          Row(
                                            children: [
                                              Icon(Icons.date_range,color: Colors.blueAccent,),
                                              Text('Date ${itemearn[index]['date']}'),
                                            ],
                                          ),
                              Row(
                                children: [
                                  Icon(Icons.add,color: Colors.green,),
                                  Text('Earn: RM${itemearn[index]['total']}',style: TextStyle(color:Colors.green),),
                                ],
                              ),
                                    ],
                                  ),
                                ),
                              )
                              
                            ],
                          ),
                        );

                    }),
                )
              ],
            ),
          ),
        );
      }
    
      void _loadEarn() async{
          ProgressDialog pr = new ProgressDialog(context,isDismissible: true,type: ProgressDialogType.Normal);
          pr.style(message:"Loading...");
          pr.show();
        await http.post(server+"/php/load_earn.php",body:{
              'email' :widget.user.email

          }).then((res) {
              if(res.body=="nodata"){
                titlecenter = "No record";
                itemearn = null;
                setState(() {
                  
                });
              }else{

                var extraction = json.decode(res.body);
                itemearn = extraction['earn'];
                print(itemearn);
                setState(() {
                  
                });

              }

              Future.delayed(Duration(seconds: 2)).then((value) {
                  pr.hide().whenComplete(() => {
                    print(pr.isShowing())
                  });
              });

          }).catchError((err){
            print(err);
          });
        
      }
}