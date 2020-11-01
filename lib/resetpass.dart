import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'splashscreen.dart';

final TextEditingController _emcontroller = new TextEditingController();
final String server = "http://lawlietaini.com/hewdeliver";

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _showText = false;
  String email, newpass, code;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "Forgot password",
          style: TextStyle(color: Colors.white),
        ),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Find your account.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Enter your email.')),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _emcontroller,
                onFieldSubmitted: (value) {
                  if (value.isEmpty) {
                    Toast.show("Email empty", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    _showText = true;
                    setState(() {});
                  } else {
                    _showText = false;
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
            ),
            Visibility(
                visible: _showText,
                child: Text("Invalid email",
                    style: TextStyle(color: Colors.redAccent))),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    color: Colors.blueAccent,
                    onPressed: _pressButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 0.6,
                          color: Colors.white),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _pressButton() {
    email = _emcontroller.text;
    if (email != "" && _isEmailValid(email)) {
      ProgressDialog pr = new ProgressDialog(context,
          isDismissible: true, type: ProgressDialogType.Normal);
      pr.style(message: "Please wait...");
      pr.show();

      http.post(server + "/php/forgotpass.php", body: {
        'email' : email
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _emcontroller.text = "";
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
        if (res.body == "fail to send") {
          _showNoexist();
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Verifypass(email: email,)));
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _showNoexist() {
    print('Enter show dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email has no exist!'),
            content: const Text('Your entered email is no existing'),
            actions: <Widget>[
              FlatButton(
                child: Text('Try again'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
   Future<bool> willPopScope(BuildContext context) {
  return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('You are now in verification process'),
          content: new Text('Are you sure you wanna leave?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Yes',style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ) ??
      false;
}
}
class Verifypass extends StatefulWidget {
  final String email;
  Verifypass({Key key, this.email}) : super(key: key);
  @override
  _VerifypassState createState() => _VerifypassState();
}

class _VerifypassState extends State<Verifypass> {
 // final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _codecontroller = TextEditingController();
  String _email, _code;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _goBack(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(
              'Verification',
              style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.6),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Enter your verification code',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    'You should get a verification code from email.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: _codecontroller,
                    

                    decoration: InputDecoration(
                      labelText: "Code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,right:20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        color: Colors.blueAccent,
                        onPressed: _pressButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0.6,
                              color: Colors.white),
                        ),
                      )),
                ),
          
              ],
            ),
          ),
        ));
  }
   void _pressButton() async{
    _code = _codecontroller.text;
    _email = widget.email;
    print('enter verify code');
    if (_code.length >= 6) {
      ProgressDialog rs = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      rs.style(message: 'Verifying');
      rs.show();
      http.post(server+"/php/verycode.php", body: {
        "code": _code,
        "email": _email,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _emcontroller.text = '';
        rs.style(message: 'Verification code sent.');
        rs.show();

        if (res.body == 'code verified') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ResetPass(email: _email)));
        }

      }).catchError((err) {
        print(err);
      });
      Future.delayed(Duration(seconds: 2)).then((value) {
        rs.hide().whenComplete((){
          print(rs.isShowing());
        });
      });
    } else {
      Toast.show('Invalid code', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        _validate = true;
      });
    }
    
  }
}
  Future<bool> _goBack(BuildContext context) {
  return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('You are now in verification process'),
          content: new Text('Are you sure you wanna leave?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Yes',style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ) ??
      false;
}


class ResetPass extends StatefulWidget {
  final String email;

  ResetPass({Key key, this.email}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();

  String _pw, _email;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>_showWarning(context),
                child: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                backgroundColor: Colors.tealAccent[700],
                title: Text(
                  'Password Reset',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Reset your password now',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Your email: ${widget.email}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Type your new password',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: _pwcontroller,
                        obscureText: true,
                        
                        
                        decoration: InputDecoration(
                          labelText: "Type your new password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Type your new password again',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        obscureText: true,
                        onFieldSubmitted: (value) {
                          if (value != _pwcontroller.text) {
                            _validate = true;
                            return 'empty';
                          }
                        },
                        validator: (value) {
                          if (value != _pwcontroller.text) {
                            return "Passwords do not match.";
                          } else {
                            return null;
                          }
                        },
                        autovalidate: _validate,
                        decoration: InputDecoration(
                          labelText: "Enter your new password again",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            color: Colors.greenAccent[700],
                            onPressed: _pressButton,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.6,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ));
          }
        
          void _pressButton()async {
            _email = widget.email;
            _pw = _pwcontroller.text;
            if (_pw.length > 5) {
              ProgressDialog rs = ProgressDialog(context,
                  type: ProgressDialogType.Normal, isDismissible: false);
              rs.style(message: null);
              rs.show();
        
              http.post(server+"/php/reset.php", body: {
                "email": _email,
                "password": _pw,
              }).then((res) {
                print(res.statusCode);
                Toast.show(res.body, context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                _emcontroller.text = '';
                rs.style(message: 'Password changed successfully.');
                rs.show();
                Future.delayed(Duration(seconds: 2)).then((value) {
                  rs.hide().whenComplete(() {
                    print(rs.isShowing());
                  });
                });

                if (res.body == 'Passwords changed') {
                                               Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              SplashScreen()),
                                                  (Route<dynamic> route) =>
                                                      false);
                }
              }).catchError((err) {
                print(err);
              });
            } else {
              Toast.show('Invalid password', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              setState(() {
                _validate = true;
              });
            }
          }
        
          Future<bool> _showWarning(BuildContext context) {

            
   return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('You are now in Reset password process'),
          content: new Text('Are you sure you wanna leave?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Yes'),
            ),
          ],
        ),
      ) ??
      false;
}

  
}
