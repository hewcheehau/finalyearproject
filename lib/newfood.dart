import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypv1/tabscreen/provider.dart';
import 'user.dart';
import 'food.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:convert/convert.dart';
import 'main.dart';
import 'package:toast/toast.dart';

File _image;
String pathAsset = 'asset/images/nofood.png';
final _picker = ImagePicker();
File file;

final TextEditingController _fname = TextEditingController();
final TextEditingController _ftype = TextEditingController();
final TextEditingController _faddress = TextEditingController();
final TextEditingController _fprice = TextEditingController();
final TextEditingController _fquantity = TextEditingController();

bool _validate = false;

class InsertFood extends StatefulWidget {
  final User user;
  const InsertFood({Key key, this.user}) : super(key: key);

  @override
  _InsertFoodState createState() => _InsertFoodState();
}

class _InsertFoodState extends State<InsertFood> {
  String server = 'http://lawlietaini.com/hewdeliver';
  String defaultValue = 'Pick up';
  String _error = "No error detected";


  final _formKey = GlobalKey<FormState>();
  bool _val = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppbar,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: Text(
            'Add food',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                child: Column(
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 35, right: 35, top: 0),
                          child: Container(
                            height: 150,
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: _image == null
                                      ? AssetImage(pathAsset)
                                      : FileImage(_image),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 20.0,
                            bottom: -10.0,
                            child: new FloatingActionButton(
                              onPressed: _addFoodphoto,
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.blueAccent,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Upload your food product photo.'),
                          _image == null
                              ? Text('(Required)',
                                  style: TextStyle(color: Colors.red))
                              : Text(''),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                        // autovalidate: true,
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _fname,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Food name',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 13.0),
                            TextFormField(
                              controller: _ftype,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Food type',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 13.0),
                             TextFormField(
                              controller: _faddress,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Shop address',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 13.0),
                            TextFormField(
                              controller: _fprice,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                labelText: 'Food price',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 13.0),
                            TextFormField(
                              controller: _fquantity,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Maximum per order',
                                contentPadding: new EdgeInsets.all(5),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                return null;
                              },
                            ),
                            Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Set availability',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Tooltip(
                                  message: 'Set this food ready to order',
                                  child: Icon(
                                    Icons.notification_important,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Switch(
                                    value: _val,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _val = newValue;
                                      });
                                    })
                              ],
                            ),
                            MaterialButton(
                                onPressed: _uploadfood,
                                minWidth: double.infinity,
                                height: 50,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.blueAccent,
                                child: Text(
                                  'Add food',
                                  style:
                                      TextStyle(fontSize: 22, color: Colors.white),
                                ))
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppbar() {
    return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: new Text("You haven't finished yet."),
                  content: new Text('Are you sure to back?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  buttonPadding: EdgeInsets.all(5),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => {Navigator.of(context).pop(false)},
                      child: Text('No'),
                    ),
                    new GestureDetector(
                      onTap: () {
                        _image = null;
                        _fname.text = null;
                        _fprice.text = null;
                        _ftype.text = null;
                        _fquantity.text = null;
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                )) ??
        Future.value(false);
  }

  Future _addFoodphoto() async {
    print('enter add photo');

    showModalBottomSheet(
        context: context,
        builder: (builder) => Container(
              padding: EdgeInsets.all(40),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () async {
                      PickedFile image = await _picker.getImage(
                          source: ImageSource.camera,
                          maxHeight: 400,
                          maxWidth: 300,
                          imageQuality: 80);
                      setState(() {
                        _image = File(image.path);
                        Navigator.of(context).pop(false);
                      });
                    },
                  ),
                  Divider(thickness: 0, color: Colors.grey[400], indent: 0),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Gallery'),
                    onTap: () async {
                      PickedFile image = await _picker.getImage(
                          source: ImageSource.gallery,
                          maxHeight: 400,
                          maxWidth: 300,
                          imageQuality: 80);
                      setState(() {
                        _image = File(image.path);
                        Navigator.of(context).pop(false);
                      });
                    },
                  ),
                ],
              ),
            ));
  }

  void _uploadfood() {
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    );
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(server + "/php/add_food.php", body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "fname": _fname.text,
      "fshop": _faddress.text,
      "ftype": _ftype.text,
      "faddress" : _faddress.text,
      "price": _fprice.text,
      "quantity": _fquantity.text,
    }).then((res) {
      print(res.statusCode);
      if (res.body == 'success') {
        _showSuccess();
      }else{
        Toast.show('Failed', context,duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
      }
    }).catchError((err){
      print(err);
    });
  }

  void _showSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Food uploaded successfully'),
            content: Icon(Icons.check_circle_outline),
            actions: <Widget>[
          
          
             CupertinoDialogAction(
               onPressed: (){
              
                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainScreen(user:widget.user)),(Route<dynamic>route) => false);
                 
                 },
               child: Text('Ok')
               
               )
            ],
          );
        });
  }
}
