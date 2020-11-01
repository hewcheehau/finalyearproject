import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fypv1/resetpass.dart';
import 'package:fypv1/selectRegister.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'user.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:async/async.dart';

String urlLogin  = 'http://lawlietaini.com/hewdeliver/php/login.php';
String urlGetuser = '';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  String _email = "";
  String _password = "";
  int countE = 0;

  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
     saveperf(_isSelected);

          });
        }
  @override
  void initState(){

    print(_email.length);
    loadpref();
      radioButton(_isSelected);
      
        print('Init: $_email');
        super.initState();
      }
          
            @override
            Widget build(BuildContext context) {
              return new Scaffold(
                            body: Stack(children: <Widget>[
              /*  Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ])),
              ),*/
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                            Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20.0, 80.0, 0.0, 0.0),
                                child: Text(
                                  'Welcome,',
                                  style: TextStyle(
                                      fontSize: 45.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(35.0, 10, 0.0, 0.0),
                                child: Text(
                                  'Deliver2U.',
                                  style: TextStyle(
                                      fontSize: 45.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                            ]),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    padding: EdgeInsets.only(right: 15, top: 90),
                                    child: Image.asset(
                                      'asset/images/logofyp2.png',
                                      width: 150,
                                    )))
                          ])),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            controller: _emcontroller,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:BorderSide(color: Colors.white)
                              ),  
                              icon: Icon(
                                Icons.person,
                                color: Colors.blueAccent[400],
                              ),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            controller: _pwcontroller,
                            obscureText: true,
                            decoration: InputDecoration(
                               enabledBorder: UnderlineInputBorder(
                                borderSide:BorderSide(color: Colors.white)
                              ),  
                              icon: Icon(
                                Icons.lock,
                                color: Colors.blueAccent[400],
                              ),
                              hintText: 'Password',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                          padding: EdgeInsets.only(right: 45),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () =>{Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()))},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )),
                      SizedBox(height: 25),
                      Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 10),
                          child: GestureDetector(
                            onTap: _radio,
                            child: radioButton (_isSelected),
                          ),
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(color: Colors.black87, fontSize: 17),
                        )
                      ]),
                      SizedBox(height: 35),
                      Center(
                        child: RaisedButton(
                          padding: EdgeInsets.all(0),
                          highlightColor: Colors.blueAccent,
                          elevation: 0,
                          textColor: Colors.white,
                          onPressed: _onLogin,
                                              color: Colors.transparent,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(90, 18, 90, 18),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    gradient: LinearGradient(colors: <Color>[
                                                      Color(0xFF0D47A1),
                                                      Color(0xFF1976D2),
                                                      Color(0xFF42A5F5),
                                                    ])),
                                                child: Text('Login', style: TextStyle(fontSize: 20)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Column(
                                                children: <Widget>[
                                                  Divider(
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              )),
                                              Padding(
                                                padding: const EdgeInsets.all(9.0),
                                                child: GestureDetector(
                                                    onTap: _selectType,
                                                    child: Text(
                                                      "Don't have account? Register now.",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue[700],
                                                          fontWeight: FontWeight.bold),
                                                    )),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                children: <Widget>[
                                                  Divider(
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ]),
                              );
                                          }
                                        
                                          Widget radioButton (bool isSelected) {
                                              
                                              setState(() {
                                                
                                              });
                                              return Container(
                                              width: 16.0,
                                              height: 16.0,
                                              padding: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 2.0, color: Colors.black),
                                              ),
                                              child: isSelected
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green,
                                                      ),
                                                    )
                                                  : Container());
                                          }
                                          void _selectType() {
                                            print('Go to select acc typ');
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) => SelectAccountType()));
                                          }
                                        
                                          void _onLogin(){
                                            
                                            _email = _emcontroller.text;
                                            _password = _pwcontroller.text;
                    
                                            if(_isEmailValid(_email)&& (_password.length>4)){
                                                ProgressDialog pr = new ProgressDialog(context, type:ProgressDialogType.Normal,isDismissible: false);
                    
                                                pr.style(message:"Login in");
                                                pr.show();
                                                http.post(urlLogin, body:{
                    
                                                  "email" : _email,
                                                  "password": _password,
                    
                                                }).then((res) {
                                                  
                                                  print(res.statusCode);
                                                  print("Go to user data");
                    
                                                  var string = res.body;
                                                  List dres = string.split(",");
                    
                                                  print(dres);
                                                  Toast.show(dres[0], context,
                                                  duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                    
                                                  if(dres[0]=="success"){

                                                    
                                                    Future.delayed(Duration(seconds: 2)).then((value) {
                                                      pr.hide().whenComplete(() {
                                                        print(pr.isShowing());
                                                      });
                                                    });
                                                    
                                                    print(dres[0]);
                    
                                                    User user = new User(
                                                        name: dres[1],
                                                        email: dres[2],
                                                        phone: dres[3],
                                                        type: dres[4],
                                                        credit: dres[5],
                                                        datereg: dres[6],
                                                        address: dres[7],
                                                        
                                                        quantity: '0'
                                                    );
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(user:user)));
                                                  }
                                                  else{
                                                    print('failed');
                                                     Future.delayed(Duration(seconds: 2)).then((value) {
                                                      pr.hide().whenComplete(() {
                                                        print(pr.isShowing());
                                                      });
                                                    });
                                                  }
                                                });
                    
                                            }
                                                                  
                                              }
                                            
                                              bool _isEmailValid(String email) {
                    
                                                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                                              }
                    
                     
          
            void saveperf(bool newValue) async{
    
                print('Inside saveperf');
                _email = _emcontroller.text;
                _password = _pwcontroller.text;
                print(newValue);
                SharedPreferences prefs = await SharedPreferences.getInstance();
    
                if(newValue) {
    
                  if(_isEmailValid(_email)&&(_password.length>5)){
                    await prefs.setString('email', _email);
                    await prefs.setString('pass', _password);
                    print('Save pref $_email');
                    print('Save pref $_password');
    
                    prefs.setInt('count', countE);
                    Toast.show('Preferences have been saved', context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                else{
                 
                  print('No email');
                  setState(() {
                    _isSelected = false;
                  });
                  Toast.show('Check your credentials', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                }
                }else{
    
                  await prefs.setString('email', '');
                  await prefs.setString('pass', '');
    
                  setState(() {
                    _emcontroller.text = '';
                    _pwcontroller.text = '';
                    _isSelected = false;
                  });
                  print('Remove pref');
                  Toast.show('Preferences have been removed.', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);  
                }
    
            }
    
      void loadpref() async{

        SharedPreferences prefs = await SharedPreferences.getInstance();
        _email = (prefs.getString('email'));
        _password = (prefs.getString('pass'));
        print(_email);
        print(_password);

        if(_email != null){
          if(_email.length >1){
            _emcontroller.text = _email;
            _pwcontroller.text = _password;
            setState(() {
              _isSelected = true;
            });
          }else{
            print('No pref');
            setState(() {
              _isSelected = false;
            });
          }
        }
     /*   setState(() {
          _isSelected = false;
        });*/
      }

  Future<bool> _onBackPressAppBar() {
  }
}
