import 'package:flutter/material.dart';
import 'package:fypv1/newfood.dart';
import 'package:fypv1/tabscreen/orderfood.dart';
import 'package:fypv1/tabscreen/tabscreen.dart';
import 'package:fypv1/tabscreen/transporter.dart';
import 'package:fypv1/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tabscreen/profilescreen.dart';
import 'tabscreen/tabscreen.dart';
import 'tabscreen/tabscreen2.dart';
import 'package:fypv1/tabscreen/tabscreendemo.dart';
import 'tabscreen/cartpage.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'tabscreen/trymap.dart';
import 'tabscreen/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final VoidCallback onBadge;

  const MainScreen({Key key, this.user, this.onBadge}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;
  List itemCart;
  int currentTabIndex = 0;
  int count = 0;
  bool _isVisible = false;
  String server = "http://lawlietaini.com/hewdeliver";
  bool _isEmpty = false;
  FirebaseMessaging _fcm = FirebaseMessaging();
  String token1;

  void firebaseListerners() {
    _fcm.getToken().then((token) {
      print('Token is ' + token);
      token1 = token;
      setState(() {});
      _loadUser();
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseListerners();

    print('mainscreen;');
    if (widget.user.type == 'Food Buyer' ||
        widget.user.type == 'unregistered') {
      tabs = [
        MainPage(user: widget.user),
        OrderFoodPage(user: widget.user),
        ProfileScreen(user: widget.user),
      ];
    } else if (widget.user.type == 'Transporter') {
      tabs = [
        TransporterScreen(user: widget.user),
        MapSample(),
        ProfileScreen(user: widget.user),
      ];
    } else {
      tabs = [
        ProviderScreen(user: widget.user),
        OrderFoodPage(user: widget.user),
        ProfileScreen(user: widget.user),
      ];
    }
  }

  String $pagetitle = "Walking-distance";

  onTapped(int index) async {
    setState(() {
      currentTabIndex = index;
      print('tap here');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        iconSize: 30,
        elevation: 5,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          /* BottomNavigationBarItem(
                  icon: Badge(
                    showBadge: _isEmpty,
                    badgeContent: Text(count.toString(),
                        style: TextStyle(color: Colors.white)),
                    child: Icon(MdiIcons.cart),
                  ),
                  title: Text('Cart',style: TextStyle(fontWeight: FontWeight.bold))),*/
          /*  BottomNavigationBarItem(
                      icon: new Stack(
                        children: <Widget>[
                          new Icon(MdiIcons.cart),
                          count > 0
                              ? Visibility(
                                  visible: _isVisible,
                                  child: new Positioned(
                                    right: 0,
                                    child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 13,
                                          maxHeight: 12,
                                        ),
                                        child: new Text(
                                          "${count}",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                )
                              : Visibility(
                                  visible: false,
                                  child: Container(
                                    child: Text('s'),
                                  ),
                                )
                        ],
                      ),
                      title: Text('Cart')),*/
          BottomNavigationBarItem(
              icon: _statusType(),
              title: Text("Delivery",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("Profile",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _loadCart(int _num) async {
    _isVisible = false;
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    pr.style(message: "Loading Cart");
    pr.show();
    String urlLoadCart = server + "/php/load_cart.php";
    http.post(urlLoadCart, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      Future.delayed(Duration(seconds: 2)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
      if (res.body == "Cart Empty") {
        widget.user.quantity = "0";

        return;
      }

      setState(() async {
        var extractdata = json.decode(res.body);
        itemCart = extractdata["cart"];

        for (int i = 0; i < itemCart.length; i++) {
          _num = int.parse(itemCart[i]['cquantity']) + _num;
        }
        if (_num > 0) {
          _isEmpty = true;
        }
        print('helo' + _num.toString());
        count = _num;
        //_amountPayable = _totalPrice + double.parse(_deliveryCharge);

        Future.delayed(Duration(seconds: 1)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
      });
    }).catchError((err) {
      print(err);
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    Future.delayed(Duration(seconds: 1)).then((value) {
      pr.hide().whenComplete(() {
        print(pr.isShowing());
      });
    });
  }

  Widget _statusType() {
    if (widget.user.type == 'Food Buyer') {
      return Icon(Icons.directions_walk);
    } else if (widget.user.type == "Transporter") {
      return Icon(Icons.motorcycle);
    } else {
      return Icon(Icons.notification_important);
    }
  }

  void _loadPref() async {
    int _hold = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hold = (prefs.getInt("cquantity"));
    setState(() {
      if (_hold > 0) {
        _isEmpty = true;
        count = _hold;
        return;
      }
    });
  }

  Future init() async {
    this._loadPref();
  }

  void _loadUser() {
    print('enter user inform :' + token1);

    if (widget.user.token == null || widget.user.token == '') {
      widget.user.token = token1;

      http.post(server + "/php/add_token.php", body: {
        'email': widget.user.email,
        'token': token1,
      }).then((res) {
        if (res.body == 'success') {
          print('success added token');
        } else {
          print('failed add token');
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      print('got token');
    }
  }
}
