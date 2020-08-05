import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/configsize.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_design_icons_flutter/icon_map.dart';

final _picker = ImagePicker();

class TabScreen4 extends StatefulWidget {
  final User user;

  const TabScreen4({Key key, this.user}) : super(key: key);

  @override
  _TabScreen4State createState() => _TabScreen4State();
}

class _TabScreen4State extends State<TabScreen4> {
  String server = "http://lawlietaini.com/hewdeliver";
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    print('profile screen');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    parsedDate = DateTime.parse(widget.user.datereg);
    return Scaffold(
      backgroundColor: Color(0xffF8F8FA),
      body: Stack(overflow: Overflow.visible, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ])),
          height: screenHeight / 2.3,
        ),
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                child: Text('Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Rock Salt',
                        letterSpacing: 1.5)),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: screenWidth / 3.0,
                        height: screenHeight / 5.8,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width:20.0,color: Colors.white),
                          color: Colors.transparent,
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              server + "/profile/${widget.user.email}.jpg?" ??
                                  server + "/profile/default.jpg?",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle),
                          ),
                          placeholder: (context, url) => new SizedBox(
                            height: 10.0,
                            width: 10.0,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => new Icon(
                            Icons.camera_front,
                            size: 65.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        child: Table(
                          defaultColumnWidth: FlexColumnWidth(1.0),
                          columnWidths: {
                            0: FlexColumnWidth(3.5),
                            1: FlexColumnWidth(20.5)
                          },
                          children: [
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    height: 10,
                                    child: Icon(
                                      Icons.verified_user,
                                      color: Colors.blue[100],
                                    )),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  height: 60,
                                  child: Text(
                                    widget.user.name,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    height: 10,
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.blue[100],
                                    )),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  height: 50,
                                  child: Text(
                                    widget.user.email,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.lightBlueAccent),
                          ),
                          child: Icon(
                            Icons.phone_iphone,
                            color: Colors.blue[600],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          child: Text(
                            widget.user.phone,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  MdiIcons.typewriter,
                                  color: Colors.white,
                                ),
                                Text(
                                  widget.user.type,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              /*  Card(
                elevation: 6,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              
                              onTap: _takePicture,
                              child: Container(
                                  height: screenHeight / 4.8,
                                  width: screenWidth / 3.2,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width:2.0)
                                  ),
                                  child: CachedNetworkImage(
                                    
                                    fit: BoxFit.cover,
                                    imageUrl: server + "/profile/default.jpg?",
                                    placeholder: (context, url) => new SizedBox(
                                      height: 10.0,
                                      width: 10.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(
                                      Icons.camera_enhance,
                                      size: 65,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Container(
                                  child: Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    columnWidths: {
                                      0: FlexColumnWidth(3.5),
                                      1: FlexColumnWidth(6.5),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                              widget.user.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text('Email',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                              widget.user.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text('Phone',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                              widget.user.phone,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text('Joined since',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                              widget.user.datereg,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Divider(
                                height: 2,
                                color: Color.fromRGBO(101, 255, 218, 50))
                          ],
                        )
                      ],
                    )),
              ),
              */
              Container(
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Joined: " + f.format(parsedDate),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 25),
              Container(
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  shrinkWrap: true,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person_outline,
                              color: Colors.blueAccent,
                            ),
                            Text('Change Your Name'),
                          ],
                        )),
                    Divider(
                      height: 2,
                      color: Colors.grey[850],
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.alternate_email,
                                color: Colors.blueAccent),
                            Text('Change Email')
                          ],
                        )),
                    SizedBox(height: 10),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.lock_outline, color: Colors.blueAccent),
                            Text('Change Password')
                          ],
                        )),
                    SizedBox(height: 10),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.settings_phone,
                                color: Colors.blueAccent),
                            Text('Change Phone No')
                          ],
                        )),
                    SizedBox(height: 10),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.work, color: Colors.blueAccent),
                            Text('Change Account Type')
                          ],
                        )),
                    SizedBox(height: 10),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.exit_to_app, color: Colors.redAccent),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                    MaterialButton(
                        onPressed: _changeName,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.person_outline),
                            Text('Change your name')
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void _takePicture() async {
    print('enter take picture');
    if (widget.user.name == "unregistered") {
      Toast.show("Please login or register to continue", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue[600],
                  ),
                  title: Text('View Profile Picture'),
                  onTap: () async {
                    Navigator.pop(context);
                    Hero(
                      tag: 'Profile Picture',
                      child: Image.network(
                          server + "/profile/${widget.user.email}.jpg?"),
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(user: widget.user),
                        ));
                  },
                ),
                Divider(
                  thickness: 0,
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_front,
                    color: Colors.blue[600],
                  ),
                  title: Text('Take Photo'),
                  onTap: () async {
                    if (widget.user.name == "unregistered") {
                      Toast.show('Please login or register', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    PickedFile _image = await _picker.getImage(
                      source: ImageSource.camera,
                      maxHeight: 400,
                      maxWidth: 300,
                      imageQuality: 70,
                    );
                    if (_image == null) {
                      Toast.show("Please upload your profile picture", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      final File file = File(_image.path);
                      String base64Image = base64Encode(file.readAsBytesSync());
                      http.post(server + "/php/upload_image.php", body: {
                        "encoded_string": base64Image,
                        "email": widget.user.email
                      }).then((res) {
                        print(res.body);
                        if (res.body == "success") {
                          setState(() {
                            DefaultCacheManager manager =
                                new DefaultCacheManager();
                            manager.emptyCache();
                            Navigator.pop(context);
                          });
                        } else {
                          Toast.show('Failed', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    }
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
                    if (widget.user.name == "unregistered") {
                      Toast.show('Please login or register', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    PickedFile _image = await _picker.getImage(
                      source: ImageSource.gallery,
                      maxHeight: 400,
                      maxWidth: 300,
                      imageQuality: 70,
                    );
                    if (_image == null) {
                      Toast.show("Please upload your profile picture", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      final File file = File(_image.path);
                      String base64Image = base64Encode(file.readAsBytesSync());
                      http.post(server + "/php/upload_image.php", body: {
                        "encoded_string": base64Image,
                        "email": widget.user.email
                      }).then((res) {
                        print(res.body);
                        if (res.body == "success") {
                          setState(() {
                            DefaultCacheManager manager =
                                new DefaultCacheManager();
                            manager.emptyCache();
                            Navigator.pop(context);
                          });
                        } else {
                          Toast.show('Failed', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    }
                  },
                )
              ],
            ),
          );
        });

    /*PickedFile _image = await _picker.getImage(
                            source: ImageSource.camera,
                            maxHeight: 400,
                            maxWidth: 300,
                            imageQuality: 70,
                          );
                          if (_image == null) {
                            Toast.show("Please upload your profile picture", context,
                                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          } else {
                            final File file = File(_image.path);
                            String base64Image = base64Encode(file.readAsBytesSync());
                            http.post(server + "/php/upload_image.php", body: {
                              "encoded_string": base64Image,
                              "email": widget.user.email
                            }).then((res) {
                              print(res.body);
                              if (res.body == "success") {
                                setState(() {
                                  DefaultCacheManager manager = new DefaultCacheManager();
                                  manager.emptyCache();
                                });
                              } else {
                                Toast.show('Failed', context,
                                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                              }
                            }).catchError((err) {
                              print(err);
                            });
                          }*/
  }

  void _changeName() {}
}

class DetailScreen extends StatefulWidget {
  final User user;
  const DetailScreen({Key key, this.user}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
