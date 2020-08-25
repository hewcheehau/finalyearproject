import 'package:flutter/material.dart';
import 'package:fypv1/login.dart';
import 'package:fypv1/splashscreen.dart';
import 'package:fypv1/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/configsize.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'profiledetail.dart';

final _picker = ImagePicker();

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String server = "http://lawlietaini.com/hewdeliver";
  double screenHeight, screenWidth;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final f2 = new DateFormat('dd-MM-yyyy');
  DateTime now = DateTime.now();
  bool _isFoodBuyer = true;
  bool _isTransporter = true;
  bool _isProvider = true;
  bool _isLoading = false;

  var parsedDate;
  bool _dateShow = true;
  @override
  void initState() {
    super.initState();
    print('profile screen');
    switch (widget.user.type) {
      case "Food Buyer":
        _isFoodBuyer = false;
        break;
      case "Transporter":
        _isTransporter = false;
        break;
      case "Food Provider":
        _isProvider = false;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (widget.user.name == "unregistered") {
      _dateShow = false;
    } else {
      parsedDate = DateTime.parse(widget.user.datereg);
    }
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
          height: screenHeight / 1.7,
        ),
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12.0),
                    alignment: Alignment.centerLeft,
                    child: Text('Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Rock Salt',
                            letterSpacing: 1.5)),
                  ),
                  Container(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        widget.user.type,
                        style: TextStyle(color: Colors.grey[350], fontSize: 25),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              server + "/profile/${widget.user.email}.jpg" ??
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
                    /*   Expanded(
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
                    ),*/
                  ],
                ),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(widget.user.name ?? "Unregistered user",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: _dateShow,
                        child: Text(
                          "Joined since  " + f2.format(parsedDate ?? now),
                          style: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          _onSwapAccount();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Switch Account Type',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 400.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
        ),
        Container(
            margin: EdgeInsets.only(top: 350),
            color: Colors.transparent,
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(20.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      Container(
                        child: Card(
                          elevation: 5,
                          child: MaterialButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.credit_card,
                                  size: 35,
                                  color: Colors.blue,
                                ),
                                Text('My Credit'),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          elevation: 5,
                          child: MaterialButton(
                            onPressed: () {
                              if(widget.user.email == 'unregistered'){
                                Toast.show('Please register/login', context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                                return;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileDetail(user: widget.user)));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person_outline,
                                  size: 35,
                                  color: Colors.blueGrey[300],
                                ),
                                Text('Manage Privacy')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          elevation: 5,
                          child: MaterialButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.settings,
                                  size: 35,
                                  color: Colors.blue,
                                ),
                                Text('Settings')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          elevation: 5,
                          child: MaterialButton(
                            onPressed: () {
                              _logout();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.exit_to_app,
                                  size: 35,
                                  color: Colors.red[600],
                                ),
                                Text('Logout')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
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

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.user.email != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Row(
                  children: <Widget>[
                    Text('Log out'),
                    Icon(Icons.warning),
                  ],
                ),
                content: Text('Are you sure want to logout from your account?'),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      prefs.setString('email', '');
                      prefs.setString('pass', '');
                      print('Logout');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  )
                ],
              ));
    }
  }

  void _onSwapAccount() {
    String type1, type2;

    if (widget.user.name == 'unregistered') {
      Toast.show('Please register/login', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Row(
                children: <Widget>[
                   Text('Select Account Type'),
                   Icon(Icons.swap_horiz)
                ],
              ),
              backgroundColor: Colors.grey[30],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: <Widget>[
                Visibility(
                  visible: _isFoodBuyer,
                  child: SimpleDialogOption(
                    onPressed: () {
                      
                            showDialog(context: context,builder:(context)=>AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        title: Text('Change to Food buyer mode?'),
                        actions: <Widget>[
                          MaterialButton(onPressed: (){
                            
                            String type= 'Food Buyer';
                            http.post(server+'/php/update_profile.php',body: {
                              'email':widget.user.email,
                              'type' : type,
                            }).then((res) {
                              if(res.body=='success'){
                                setState(() {
                                  
                                });
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SplashScreen()), (Route<dynamic>route) => false);
                              }
                            });

                          },
                          child: Text('Yes'),),
                           MaterialButton(onPressed: ()=>{Navigator.of(context).pop()},
                          child: Text('No'),),
                        ],
                      ));
                    },
                    child: Text('Food Buyer'),
                  ),
                ),
                Divider(),
                Visibility(
                  visible: _isTransporter,
                  child: SimpleDialogOption(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      showDialog(context: context,builder:(context)=>AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        title: Text('Change to transporter mode?'),
                        actions: <Widget>[
                          MaterialButton(onPressed: (){
                            
                            String type= 'Transporter';
                            http.post(server+'/php/update_profile.php',body: {
                              'email':widget.user.email,
                              'type' : type,
                            }).then((res) {
                              if(res.body=='success'){
                             //   Navigator.of(context).pop();
                               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SplashScreen()), (Route<dynamic>route) => false);
                              }
                            });

                          },
                          child: Text('Yes'),),
                           MaterialButton(onPressed: ()=>{Navigator.of(context).pop()},
                          child: Text('No'),),
                        ],
                      ));
                    },
                    child: Text('Transporter'),
                  ),
                ),
                Divider(),
                Visibility(
                  visible: _isProvider,
                  child: SimpleDialogOption(

                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      showDialog(context: context,builder:(context)=>AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        title: Text('Change to food provider mode?'),
                        actions: <Widget>[
                          MaterialButton(onPressed: (){
                            
                            String type= 'Food Provider';
                            http.post(server+'/php/update_profile.php',body: {
                              'email':widget.user.email,
                              'type' : type,
                            }).then((res) {
                              if(res.body=='success'){
                             //   Navigator.of(context).pop();
                               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SplashScreen()), (Route<dynamic>route) => false);
                              }
                            });

                          },
                          child: Text('Yes'),),
                           MaterialButton(onPressed: ()=>{Navigator.of(context).pop()},
                          child: Text('No'),),
                        ],
                      ));
                    },
                    child: Text('Food Provider'),
                  ),
                ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      
                      onPressed: ()=>{Navigator.of(context).pop()},child: Text('Exit'),),
                  )
              ],
            ));
  }
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
