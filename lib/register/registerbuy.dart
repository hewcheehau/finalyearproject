import 'package:flutter/material.dart';
import 'package:fypv1/login.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:async/async.dart';

String pathAsset = 'asset/images/profile.jpg';
String urlUpload = 'http://lawlietaini.com/hewdeliver/php/register1.php';
File _image;
File file;
final _picker = ImagePicker();


final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _pwcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String type;

String _name, _email, _password, _phone;
bool _validate = false;

class RegisterBuyer extends StatefulWidget {
  final String type;
  const RegisterBuyer({Key key, File image, this.type}) : super(key: key);
  @override
  _RegisterBuyerState createState() => _RegisterBuyerState();
}

class _RegisterBuyerState extends State<RegisterBuyer> {



  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'Registration',
            style: TextStyle(letterSpacing: 0.6),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text("You haven't finished."),
                  content: new Text("Are you sure to back?"),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    new GestureDetector(
                      onTap: () {
                        _image = null;
                        _namecontroller.text = "";
                        _phcontroller.text = "";
                        _pwcontroller.text = "";
                        _emcontroller.text = "";
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    )
                  ],
                )) ??
        false;
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String server = "http://lawlietaini.com/hewdeliver";
    
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 5),
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(file),
                        fit: BoxFit.fill)),
              ),
            ),
            Positioned(
                right: 50,
                bottom: 0.0,
                child: new FloatingActionButton(
                  child: const Icon(Icons.camera_alt),
                  backgroundColor: Colors.black54,
                  onPressed: _takePicture,
                ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _namecontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide())),
          style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: _emcontroller,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (!_isEmailValid(value)) {
              return "Email format is invalid";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide()),
          ),
          style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
        ),
        SizedBox(height: 15),
        TextFormField(
          obscureText: true,
          controller: _pwcontroller,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (value) {
            if (value.isEmpty) {
              return "Password cannot be empty.";
            } else if (value.length > 0 && value.length < 6) {
              return "Password should be more than 6 characters.";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: _phcontroller,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value.isEmpty) {
              return "Phone cannot be  empty.";
            } else if (value.length > 0 && value.length < 6) {
              return "Phone is invalid";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'Phone number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          style: TextStyle(
            fontSize: 15,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Center(
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            highlightColor: Colors.blueAccent,
            elevation: 0,
            textColor: Colors.white,
            onPressed: _uploadData,
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.fromLTRB(110, 18, 110, 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ])),
              child: Text('Register', style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            child: Text(
              'Already have an account?Sign in',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }

  void _choose() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    PickedFile _image = await _picker.getImage(
                      source: ImageSource.camera,
                      maxHeight: 400,
                      maxWidth: 300,
                      imageQuality: 70
                    );

                    setState(() {
                      Navigator.pop(context);
                      
                    });
                    ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text('Gallery'),
                      onTap: () async {
                      /*  _image = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                            maxHeight: 450,
                            maxWidth: double.infinity);*/
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _uploadData () {
   // _validateInput();
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_phone.length > 5) &&
        (_image != null)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      print('123');
      file = File(_image.path);
      String base64Image = base64Encode(file.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "type": type,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        _namecontroller.text = "";
        _emcontroller.text = "";
        _pwcontroller.text = "";
        _phcontroller.text = "";
        if (res.body == "success") {
          pr.hide().then((isHidden){
              print(isHidden);
          });
          pr.hide();
          _showSuccessRegister();
        }
        if (res.body == "failed") {
          print('enter fail area.');
          _showDialog();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show('Check your registration information', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      //text form was validated.
      form.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showSuccessRegister() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thanks for your registration.'),
            content: const Text('Please get verify account from your email'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          );
        });
  }

  void _showDialog() {
    print('Enter dialog space');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email has already been taken!'),
            content:
                const Text('Your entered email has been registered by others.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Try another'),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text('Already have account?'))
            ],
          );
        });
  }
  void _takePicture() async {
    print('enter take picture');
   

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
               
               
                ListTile(
                  leading: Icon(
                    Icons.camera_front,
                    color: Colors.blue[600],
                  ),
                  title: Text('Take Photo'),
                  onTap: () async {
                    
                    PickedFile _image = await _picker.getImage(
                      source: ImageSource.camera,
                      maxHeight: 400,
                      maxWidth: 300,
                      imageQuality: 70,
                    );
                        setState(() {
                          file = File(_image.path);
                          
                          Navigator.of(context).pop(false);
                          
                        });
                  
                  },
                ),
                Divider(
                  thickness: 0,
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_album,
                    color: Colors.blue[600],
                  ),
                  title: Text('Gallery'),
                  onTap: () async {
                    
                    PickedFile _image = await _picker.getImage(
                      source: ImageSource.gallery,
                      maxHeight: 400,
                      maxWidth: 300,
                      imageQuality: 70,
                    );
                    
                   
                  },
                )
              ],
            ),
          );
        });}
}
