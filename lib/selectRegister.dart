import 'package:flutter/material.dart';
import 'package:fypv1/register/registerbuy.dart';


class SelectAccountType extends StatefulWidget {
  SelectAccountType({Key key}) : super(key: key);

  @override
  _SelectAccountTypeState createState() => _SelectAccountTypeState();
}

class _SelectAccountTypeState extends State<SelectAccountType> {
  String drawdownvalue = 'User Type';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      home: Scaffold(
        
        body: SafeArea(
          top: true,
          child: Stack(
            children: <Widget>[
              AppBar(
                centerTitle: true,
                title: Text('Register Type',style: TextStyle(color:Colors.black87,fontSize: 25),),
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: ()=>Navigator.of(context).pop(),
                icon:Icon(Icons.arrow_back_ios,color: Colors.black87,size: 25,)),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left:50),
                      child: Text('Select user type to continue.',style: TextStyle(fontSize:30),)),
                    SizedBox(height:30),
                    DropdownButton<String>(
                      
                      value: drawdownvalue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 35,
                      elevation: 5,
                      
                      
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String newvalue) {
                        setState(() {
                          drawdownvalue = newvalue;
                        });
                      },
                      items: <String>[
                        'User Type',
                        'Food Buyer',
                        'Transporter',
                        'Food Provider'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(fontSize:20),),
                        );
                      }).toList(),
                    ),
                    SizedBox(height:30),
                    RaisedButton(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.blueAccent,
                        elevation: 0,
                        textColor: Colors.white,
                        onPressed: () {
                          if(drawdownvalue=='Food Buyer'){
                              print('buyer');
                              Navigator.of(context).pop(true);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterBuyer(type: drawdownvalue,)));

                          }else if(drawdownvalue=='Food Provider'){
                              print('food');
                          }else if(drawdownvalue=='Transporter'){
                            print('raider');
                          }else{

                          }
                         
                        },
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ])),
                          child: Text('Next', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      SizedBox(height:10),
                    Container(
                   //  child: Image.asset('asset/images/cover0.png',height: 250,width: double.infinity,),
                    )
                  ],
                ),
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}
