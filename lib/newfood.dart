import 'package:flutter/material.dart';
import 'user.dart';
import 'food.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:convert/convert.dart';
import 'main.dart';

File _image;
String pathAsset = 'asset/images/nofood.png';
final TextEditingController _fname = TextEditingController();
final TextEditingController _ftype = TextEditingController();
final TextEditingController _fprice = TextEditingController();
final TextEditingController _fquantity = TextEditingController();

class InsertFood extends StatefulWidget {
  final User user;
  const InsertFood({Key key, this.user}) : super(key: key);

  @override
  _InsertFoodState createState() => _InsertFoodState();
}

class _InsertFoodState extends State<InsertFood> {
  String server = 'http://lawlietaini.com/hewdeliver';
  String defaultValue = 'Pick up';
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
            'New food',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Column(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 35, right: 35, top: 0),
                      child: Container(
                        height: 200,
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
                      Text('Upload food photo.'),
                      _image == null
                          ? Text('(Required)',
                              style: TextStyle(color: Colors.red))
                          : Text(''),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Form(
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
                          controller: _fprice,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
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
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Maximum per order',
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
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Set availability',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Tooltip(
                              message: 'Set this food ready to order',
                              child: Icon(Icons.edit),
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
                            onPressed: () {},
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
    );
  }

  Future<bool> _onBackPressAppbar() {
    showDialog(context: context,builder:(BuildContext context)=>AlertDialog(
      title: Text('Are you sure?'),
      content: Text("You haven't finished yet to upload your food."),
      actions: <Widget>[
        FlatButton(onPressed: (){
          _image = null;
    _fname.text = null;
    _fprice.text = null;
    _ftype.text = null;
    _fquantity.text = null;

    Navigator.pop(context,
        MaterialPageRoute(builder: (context) => MainScreen(user: widget.user)));
    return Future.value(false);
        }, child: Text('Yes,exit')),
        FlatButton(onPressed: (){Navigator.of(context).pop();
        
        return Future.value(true);
        }, child: Text('No')),
        
      ],
    ));
    
  }
}
