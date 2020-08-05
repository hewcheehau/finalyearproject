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

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key key, this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String server = "http://lawlietaini.com/hewdeliver";
  List itemCart;
  double screenHeight, screenWidth;
  bool _payment;
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

  String titlecenter = "Loading your cart...";

  @override
  void initState() {
    super.initState();
    print('cart screen');
    //  refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadCart();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'My Cart',
            style: TextStyle(color: Colors.lightBlue),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.lightBlue,
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
                                                          Container(
                                                              padding: EdgeInsets.only(left: 10),
                                                              alignment: Alignment.topLeft,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Text("Delivery address"),
                                                                      FlatButton(
                                                                          onPressed: () =>
                                                                              {_loadMapDialog()},
                                                                          child: Icon(
                                                                            Icons.location_on,
                                                                            color:
                                                                                Colors.lightBlue,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.fromLTRB(35, 0, 35, 0),
                                                            child: Table(
                                                              defaultColumnWidth:
                                                                  FlexColumnWidth(1.0),
                                                              columnWidths: {
                                                                0: FlexColumnWidth(7),
                                                                1: FlexColumnWidth(5),
                                                              },
                                                              children: [
                                                                TableRow(children: [
                                                                  TableCell(
                                                                    child: Container(
                                                                      height: 60,
                                                                      child:
                                                                          Text('Current address'),
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Container(
                                                                      height: 60,
                                                                      child: Text(
                                                                        curaddress ??
                                                                            "Address not set.",
                                                                        maxLines: 5,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                                TableRow(children: [
                                                                  TableCell(
                                                                    child: Container(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      height: 30,
                                                                      child: Text(
                                                                        "Order Quantity",
                                                                        style: TextStyle(
                                                                            fontSize: 20,
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
                                                                                      onTap: () {
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
                                                                              fontSize: 20,
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
                                                                            fontSize: 20,
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
                                                                            fontSize: 20,
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
                                                                              fontSize: 20),
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
                                                     _checkSelect==true?Text('(Select your payment method)'):Text("(Please select your payment method)",style: TextStyle(color:Colors.red),),
                                                      Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Checkbox(value: _cashOnDelivery, onChanged: (bool value){
                                                                _onCashOnDelivery(value);
                                                                                                                              }),
                                                                                                                              Text('Cash On Delivery',style: TextStyle(fontSize:18),)
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                            Row(
                                                            children: <Widget>[
                                                              Checkbox(value: _credit, onChanged: (bool value){
                                                                _onDeliverCredit(value);
                                                                                                                                                                                              }),
                                                                                                                                                                                              Text('DeliverCreditPay',style: TextStyle(fontSize:18),)
                                                                                                                                                                                            ],
                                                                                                                                                                                          )
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
                                                                                                                                                                                                "/images/${itemCart[index]['id']}.jpg",
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
                                                                                                                                                                                if(_credit == false&&_cashOnDelivery==false){
                                                                                                                                                                                  _checkSelect = false;
                                                                                                                                                                                }
                                                                                                                                                                                else{
                                                                                                                                                                                  _checkSelect = true;
                                                                                                                                                                                }
                                                                                                                                                                                setState(() {
                                                                                                                                                                                  
                                                                                                                                                                                });
                                                                                                                                                                            },
                                                                                                                                                                            child: Container(
                                                                                                                                                                              
                                                                                                                                                                              child: Text(
                                                                                                                                                                                'Check out',
                                                                                                                                                                                style: TextStyle(color: Colors.white,fontSize: 18),
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
                                                                                                                                                          titlecenter = "No food in Cart.";
                                                                                                                                                        }
                                                                                                                                                  
                                                                                                                                                        setState(() {
                                                                                                                                                          var extractdata = json.decode(res.body);
                                                                                                                                                          itemCart = extractdata["cart"];
                                                                                                                                                  
                                                                                                                                                          for (int i = 0; i < itemCart.length; i++) {
                                                                                                                                                            _totalPrice = double.parse(itemCart[i]['yourprice']) + _totalPrice;
                                                                                                                                                          }
                                                                                                                                                          _amountPayable = _totalPrice + double.parse(_deliveryCharge);
                                                                                                                                                  
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
                                                                                                                                                  
                                                                                                                                                    void _updateCart(int number, int quantity) {
                                                                                                                                                      String urlLoadCart = server + "/php/update_cart.php";
                                                                                                                                                      http.post(urlLoadCart, body: {
                                                                                                                                                        "email": widget.user.email,
                                                                                                                                                        "foodid": itemCart[number]['id'],
                                                                                                                                                        "quantity": quantity.toString(),
                                                                                                                                                      }).then((res) {
                                                                                                                                                        print(res.body);
                                                                                                                                                        if (res.body == "success") {
                                                                                                                                                          _loadCart();
                                                                                                                                                        } else {}
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
                                                                                                                                                                        child: Text('Close'),
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
                                                                                                                                                  
                                                                                                                                                    void _loadLoc(LatLng loc, newSetState) {
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
                                                                                                                                                  
                                                                                                                                                    void _deleteCart() {
                                                                                                                                                      showDialog(context: 
                                                                                                                                                      context,
                                                                                                                                                      builder: (context)=>AlertDialog(
                                                                                                                                                        shape: RoundedRectangleBorder(
                                                                                                                                                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                                                                                
                                                                                                                                                        ),
                                                                                                                                                        title: new Text('Delete all items?'),
                                                                                                                                                        actions: <Widget>[
                                                                                                                                                          MaterialButton(
                                                                                                                                                            onPressed: (){
                                                                                                                                                              Navigator.of(context).pop(false);
                                                                                                                                                              http.post(server+"/php/delete_cart.php",body: {
                                                                                                                                                                "email" : widget.user.email,
                                                                                                                                                              //  "foodid": itemCart[index-1]['id'],
                                                                                                                                
                                                                                                                                                              }).then((res){
                                                                                                                                                                print(res.body);
                                                                                                                                
                                                                                                                                                                if(res.body == "success"){
                                                                                                                                                                  _loadCart();
                                                                                                                                                                }else{
                                                                                                                                                                  Toast.show("Failed", context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                                                                                                                                
                                                                                                                                                                }
                                                                                                                                                              } ).catchError((err){
                                                                                                                                                                print(err);
                                                                                                                                                              });
                                                                                                                                                              
                                                                                                                                                            },
                                                                                                                                                            child: Text('Yes'),
                                                                                                                                                          ),
                                                                                                                                                          MaterialButton(
                                                                                                                                                            onPressed: (){
                                                                                                                                                              Navigator.of(context).pop(false);
                                                                                                                                
                                                                                                                                                            },
                                                                                                                                                            child: Text('No'),
                                                                                                                                                          )
                                                                                                                                                        ],
                                                                                                                                                      )
                                                                                                                                                      );
                                                                                                                                                    }
                                                                                                                                
                                                                                                                                  void _onCashOnDelivery(bool value) => setState((){
                                                                                                                                    _cashOnDelivery = value;
                                                                                                                                    if(_cashOnDelivery){
                                                                                                                                        _credit = false;
                                                                                                                                        _updatePayment();
                                                                                                                                    }else{
                                                                                                                                      _updatePayment();
                                                                                                                                                                                                          }
                                                                                                                                                                                                        });
                                                                                                                                      
                                                                                                                                        void _updatePayment() {
                                                                                                                                          print(_amountPayable);
                                                                                                                                          setState(() {
                                                                                                                                            
                                                                                                                                          });
                                                                                                                                        }
                                                                
                                                                  void _onDeliverCredit(bool value) {

                                                                  }
}
