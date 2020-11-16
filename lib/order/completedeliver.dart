import 'package:flutter/material.dart';
import 'package:fypv1/main.dart';
import 'package:http/http.dart' as http;
import 'package:fypv1/user.dart';
import 'package:fypv1/deliver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

final TextEditingController _note = new TextEditingController();

class CompleteDeliverScreen extends StatefulWidget {
  final User user;
  final Deliver deliver;

  CompleteDeliverScreen({Key key, this.user, this.deliver}) : super(key: key);

  @override
  _CompleteDeliverScreenState createState() => _CompleteDeliverScreenState();
}

class _CompleteDeliverScreenState extends State<CompleteDeliverScreen> {
  String server = "http://lawlietaini.com/hewdeliver";
  double screenHeight, screenWidth;
  final _picker = ImagePicker();
  File _image;
  String pathAsset = 'asset/images/nofood.png';
  final _focus0 = FocusNode();
  final _focus1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _goBackPrevious,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Delivery detail'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '#Deliver:' + widget.deliver.taskid,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => {_choose()},
                child: Container(
                  height: screenHeight / 3.5,
                  width: screenWidth / 1.8,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Upload photo (optional)'),
              SizedBox(height: 12),
              MaterialButton(
                  minWidth: 250,
                  color: Colors.blueAccent,
                  onPressed: () => {_choose()},
                  child: Text(
                    "Add photo",
                    style: TextStyle(color: Colors.white),
                  )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    focusNode: _focus0,
                    controller: _note,
                    maxLines: 3,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_focus1);
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Add note (optional)',
                    ),
                  ),
                ),
              ),
              Flexible(
                  child: MaterialButton(
                minWidth: 250,
                color: Colors.blueAccent,
                onPressed: () {
                  _onCompleteFood();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => MainScreen(
                                user: widget.user,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  'Complete',
                  style: TextStyle(color: Colors.white),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _choose() async {
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
                        if (image != null) {
                          _image = File(image.path);
                        }
                        //   _cropImage();
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
                        if (image != null) {
                          _image = File(image.path);
                        }
                        Navigator.of(context).pop(false);
                      });
                    },
                  ),
                ],
              ),
            ));
  }

  _onCompleteFood() {
    String _isfinish = 'reach';
    String _totalearn = "1.50";
    http.post(server + "/php/update_deliver.php", body: {
      'email': widget.user.email,
      'note': _note.text,
      'current': _isfinish,
      'orderid': widget.deliver.orderid,
      'taskid': widget.deliver.taskid,
      'earn' : _totalearn
    }).then((res) {
      if (res.body == 'success') {
        _showSuccess();
      }
    });
  }

  void _showSuccess() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Completed order.'),
            content: Icon(
              Icons.check_circle_outline,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  Future<bool> _goBackPrevious() async {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text("Are you sure?"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: new Text("Are you sure to back?"),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Text('No'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'),
                      ),
                    )
                  ],
                )) ??
        false;
  }
}
