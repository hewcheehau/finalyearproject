import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:fypv1/user.dart';
import 'package:fypv1/food.dart';
import 'dart:convert';
import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:fypv1/main.dart';
import 'package:random_string/random_string.dart';
import 'package:fypv1/payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fypv1/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CartPage extends StatefulWidget {
  final User user;
  final Provider prd;
  const CartPage({Key key, this.user, this.prd}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String server = "http://lawlietaini.com/hewdeliver";
  List itemCart;
  double screenHeight, screenWidth;
  double _totalPrice, _amountPayable = 0.0;
  String _deliveryCharge = "1.50";
  int cQuantity = 0;
  Position _currentPosition;
  String curaddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  CameraPosition _userpos;
  bool _cashOnDelivery = false;
  bool _credit = true;
  bool _checkSelect = true;
  int _countQ = 0;
  String titlecenter = "Loading your cart...";
  String token1;
  String _tokenOwner;
  String _methodpay = "";
  int _value = 1;
  TextEditingController _address = new TextEditingController();
  String _billid = "";

  void firebaseListerners() {
    if (_tokenOwner == null || _tokenOwner == '') {
      print('no token for provider, and getting now');
      http.post(server + "/php/get_provider.php",
          body: {'owner': itemCart[0]['owner']}).then((res) {
        var extraction = res.body;
        List extract = extraction.split(',');
        print('enter take token');
        if (extract[0] == 'success') {
          setState(() {
            _tokenOwner = extract[1];
            print('the token is :' + _tokenOwner);
          });
        } else {
          print('failed');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('cart screen');
    //  refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadCart();
    _getLocation();

    //   getMessage();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _setAddress = new TextEditingController();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(user: widget.user)));
              }),
          centerTitle: true,
          title: Text(
            'My Cart',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  _deleteCart();
                })
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              itemCart == null
                  ? Flexible(
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _loadCart();
                                    });
                                  },
                                  child: Icon(MdiIcons.reload)),
                              Text(
                                titlecenter,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: itemCart == null ? 1 : itemCart.length + 2,
                        itemBuilder: (context, index) {
                          if (index == itemCart.length) {
                            return Container(
                              height: screenHeight / 2.5,
                              width: screenWidth / 2.5,
                              child: InkWell(
                                  onLongPress: () => {print("Delete")},
                                  child: Card(
                                    elevation: 3,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'SUMMARY',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 25),
                                          child: Row(
                                            children: [
                                              Text(
                                                '*Select Delivery Address*',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(25, 8, 25, 0),
                                          child: Table(
                                            defaultColumnWidth:
                                                FlexColumnWidth(1.0),
                                            columnWidths: {
                                              0: FlexColumnWidth(5),
                                              1: FlexColumnWidth(5),
                                            },
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child:
                                                      /*Container(
                                                          height: 60,
                                                          child: Text(
                                                            'Current address',
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),*/
                                                      DropdownButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color:
                                                                  Colors.black,
                                                              size: 25),

                                                          //    hint: Text('Please select address option',style: TextStyle(color:Colors.black87),),
                                                          value: _value,
                                                          items: [
                                                            DropdownMenuItem(
                                                                value: 1,
                                                                child: Text(
                                                                    'Current address')),
                                                            DropdownMenuItem(
                                                                value: 2,
                                                                child: Text(
                                                                    'Enter address')),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _value = value;
                                                            });
                                                          }),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    height: 45,
                                                    child: _value == 1
                                                        ? InkWell(
                                                            onTap: () {
                                                              _loadMapDialog();
                                                            },
                                                            child: Text(
                                                              curaddress ??
                                                                  "Address not set.",
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 45,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _address,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                      'Enter address',
                                                                  border:
                                                                      OutlineInputBorder()),
                                                            ),
                                                          ),
                                                  ),
                                                )
                                              ]),
                                              /*     : TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                          height: 60,
                                                          child: Text(
                                                            'Enter address',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          height: 60,
                                                          child: TextField(
                                                            controller:
                                                                _setAddress,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder()),
                                                          ),
                                                        ),
                                                      )
                                                    ]),*/
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 35,
                                                    child: Text(
                                                      "Order Quantity",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 35,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        cQuantity =
                                                                            int.parse(itemCart[index -
                                                                                1]['cquantity']);
                                                                        print("ENTER" +
                                                                            cQuantity.toString());
                                                                        if (cQuantity >
                                                                            1) {
                                                                          cQuantity--;
                                                                          // itemCart[index]['cquantity'] = cQuantity;
                                                                        } else {
                                                                          _showDialog();
                                                                        }
                                                                        String
                                                                            cartq =
                                                                            cQuantity.toString();
                                                                        itemCart[index -
                                                                                1]['cquantity'] =
                                                                            cartq;
                                                                        int number =
                                                                            index -
                                                                                1;
                                                                        _updateCart(
                                                                            number,
                                                                            cQuantity);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                      ),
                                                                    )),
                                                                Text(
                                                                  "${itemCart[index - 1]['cquantity']}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        cQuantity =
                                                                            int.parse(itemCart[index -
                                                                                1]['cquantity']);
                                                                        print("ENTER" +
                                                                            cQuantity.toString());
                                                                        if (cQuantity <
                                                                            int.parse(itemCart[index -
                                                                                1]['fquantity'])) {
                                                                          cQuantity++;

                                                                          // itemCart[index]['cquantity'] = cQuantity;
                                                                        }
                                                                        String
                                                                            cartq =
                                                                            cQuantity.toString();
                                                                        itemCart[index -
                                                                                1]['cquantity'] =
                                                                            cartq;
                                                                        int number =
                                                                            index -
                                                                                1;
                                                                        _updateCart(
                                                                            number,
                                                                            cQuantity);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 50,
                                                      child: Text(
                                                        itemCart[index - 1]
                                                            ['name'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 50,
                                                    child: Text(
                                                      "RM " +
                                                              _totalPrice
                                                                  .toStringAsFixed(
                                                                      2) ??
                                                          0.0,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                      "Delivery fees",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                        'RM ' + _deliveryCharge,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          }
                          if (index == itemCart.length + 1) {
                            return Container(
                              height: screenHeight / 2.4,
                              width: screenWidth / 2.5,
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "PAYMENT METHOD",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    _checkSelect == true
                                        ? Text('(Select your payment method)')
                                        : Text(
                                            "(Please select your payment method)",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Checkbox(
                                                value: _cashOnDelivery,
                                                onChanged: (bool value) {
                                                  _onCashOnDelivery(value);
                                                }),
                                            Text(
                                              'Cash On Delivery',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Checkbox(
                                                value: _credit,
                                                onChanged: (bool value) {
                                                  _onDeliverCredit(value);
                                                }),
                                            Text(
                                              'DeliverCreditPay',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          index -= 0;
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: screenHeight / 8,
                                        width: screenWidth / 2,
                                        child: CachedNetworkImage(
                                          imageUrl: server +
                                              "/images/${itemCart[index]["image"]}.jpg",
                                          placeholder: (context, url) => Center(
                                              child:
                                                  new CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(itemCart[index]['name']),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(itemCart[index]['shop'])
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Total:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "RM " + _amountPayable.toStringAsFixed(2) ?? "0.00",
                          style: TextStyle(fontSize: 23),
                        ),
                        SizedBox(width: 50),
                        MaterialButton(
                          onPressed: () {
                            if (itemCart == null) {
                              Toast.show('No food in cart', context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                              return;
                            }
                            if (_credit == false && _cashOnDelivery == false) {
                              _checkSelect = false;
                            } else {
                              _checkSelect = true;
                            }
                            if (_checkSelect) {
                              _proceedPayment();
                            }
                            setState(() {});
                          },
                          child: Container(
                            child: Text(
                              'Check out',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          color: _amountPayable != 0.0
                              ? Colors.lightBlue
                              : Colors.grey,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _loadCart() {
    _totalPrice = 0.0;
    cQuantity = 0;
    String cq = "";

    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    pr.style(message: "Updating Cart");
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
        titlecenter = "No food in Cart.";
      }

      setState(() {
        var extractdata = json.decode(res.body);
        itemCart = extractdata["cart"];

        for (int i = 0; i < itemCart.length; i++) {
          _totalPrice = double.parse(itemCart[i]['yourprice']) + _totalPrice;
          cQuantity = int.parse(itemCart[i]['cquantity']) + cQuantity;
        }
        _amountPayable = _totalPrice + double.parse(_deliveryCharge);
        widget.user.quantity = cQuantity.toString();
        firebaseListerners();
        Future.delayed(Duration(seconds: 1)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
      });
      print(_totalPrice);
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

  void _updateCart(int number, int quantity) async {
    String urlLoadCart = server + "/php/update_cart.php";
    print('enter update');

    http.post(urlLoadCart, body: {
      "email": widget.user.email,
      "foodid": itemCart[number]['id'],
      "quantity": quantity.toString(),
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadCart();
      } else {
        Toast.show("Maximum quantity", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _showDialog() {}

  void _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    print("${first.featureName}:${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show('Location is not availble...', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current location',
            snippet: 'Delivery location',
          )));
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, newSetState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  title: Text('Select New Delivery Location'),
                  actions: <Widget>[
                    Text(
                      curaddress,
                      style: TextStyle(),
                    ),
                    Container(
                      height: screenHeight / 2 ?? 600,
                      width: screenWidth ?? 360,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        },
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: 30,
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                      elevation: 10,
                      onPressed: () =>
                          {markers.clear(), Navigator.of(context).pop(false)},
                    )
                  ],
                );
              },
            );
          });
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print('in setstate');
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
              title: 'New Location', snippet: 'New Delivery Location')));

      _home = CameraPosition(target: loc, zoom: 14);
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );
      _newhomeLocation();
    });
  }

  void _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    print("${first.featureName} : ${first.addressLine}");
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  void _deleteCart() async {
    if (widget.user.quantity == '0') {
      Toast.show('No food in cart', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: new Text('Delete all items?'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    http.post(server + "/php/delete_cart.php", body: {
                      "email": widget.user.email,
                      //  "foodid": itemCart[index-1]['id'],
                    }).then((res) {
                      print(res.body);

                      if (res.body == "success") {
                        _loadCart();
                        itemCart = null;
                        _amountPayable = 0.00;
                        widget.user.quantity = "0";
                        setState(() {});
                      } else {
                        Toast.show("Failed", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  },
                  child: Text('Yes'),
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

  void _onCashOnDelivery(bool value) => setState(() {
        _cashOnDelivery = value;
        if (_cashOnDelivery) {
          _credit = false;
        } else {}
      });

  void _proceedPayment() {

    print(_amountPayable);
    print(_credit);

    setState(() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text('Confirm your order'),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      makePayment();
                    },
                    child: Text('Yes'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  )
                ],
              ));
    });
  }

  void _onDeliverCredit(bool value) => setState(() {
        _credit = value;
        if (_credit) {
          _cashOnDelivery = false;
        } else {}
      });
  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    return orderid;
  }

  

  Future<void> _payusingCredit(double newamount) async {
    print('enter pay credit: '+newamount.toString());
    double _paytotal = _totalPrice+ double.parse(_deliveryCharge);
    _billid = uuid.v1();
  
    String urlPayment = server + "/php/payment_dcp1.php";
       http.post(urlPayment, body: {
      'userid': widget.user.email,
      'amount': _paytotal.toStringAsFixed(2),
      'orderid': generateOrderid(),
      'newcr': newamount.toStringAsFixed(2),
      'billid': _billid,
      'address': curaddress
    }).then((res) {
      print(res.body);
      widget.user.credit =newamount.toStringAsFixed(2);
      _getQue();
      
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> makePayment() async {
    print('enter make payment');
    String _curaddress;

    if (_value == 1) {
      _curaddress = curaddress;
    } else {
      _curaddress = _address.text;
    }
    if (_credit) {
      _methodpay = "DCP";
        _amountPayable = _amountPayable - double.parse(widget.user.credit);
    }

    if (_amountPayable < 0) {
      
      double newamount = _amountPayable * -1;
      await _payusingCredit(newamount);
      _loadCart();
      return;
    }
    if (_cashOnDelivery) {
      print('COD');
      Toast.show('Cash On Delivery', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _methodpay = "COD";
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderId = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(orderId);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  user: widget.user,
                  val: _amountPayable.toStringAsFixed(2),
                  orderid: orderId,
                  methodpay: _methodpay,
                  tokenowner: _tokenOwner,
                  address: _curaddress,
                )));

    _loadCart();
  }

  void _enterAddress() {
    TextEditingController _address =
        new TextEditingController(text: widget.user.address);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.local_attraction_outlined),
                  Text('Enter Address'),
                ],
              ),
              content: TextField(
                controller: _address,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              actions: [
                new FlatButton(onPressed: () {}, child: Text('Submit')),
                new FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text('Back'))
              ],
            ));
  }

  Future _getQue() async {
    print('enter ' + _tokenOwner);
    if (_tokenOwner!= null) {
      var response = await http
          .post(server + "/php/notify.php", body: {"token": _tokenOwner});
      print('success');
      return json.decode(response.body);
    } else {
      print("Token is null");
    }
  }

}
