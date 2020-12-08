import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/food/fooddetail.dart';
import 'package:fypv1/splashscreen.dart';
import 'package:fypv1/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:fypv1/food.dart';
import 'package:fypv1/food/fooddetail.dart';
import 'cartpage.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List itemCart;
  List itemdata;
  int current = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curItem = "Recent";
  int cartQuantity = 0;
  int quantity = 1;
  bool _isFoodprovider = false;
  bool _isTransporter = false;
  double priceFood = 1;
  String titlecenter = "Loading available foods...";
  String server = "http://lawlietaini.com/hewdeliver";
  String dropdown = "Recent";
  int _quantityc = 0;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this._loadDate();
    this._loadCart();
    //init();

    if (widget.user.type == 'Food Provider') {
      _isFoodprovider = true;
    }
    if (widget.user.type == 'Transporter') {
      _isTransporter = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _foodController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              'TodayFood',
              style: TextStyle(color: Colors.black87, fontSize: 25),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: IconButton(
                icon: Badge(
                  alignment: Alignment.topRight,
                  showBadge: widget.user.quantity == '0' ? false : true,
                  badgeContent: Text(widget.user.quantity ?? Text('0'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  child: Icon(
                    MdiIcons.cartOutline,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  if (widget.user.name == 'unregistered') {
                    Toast.show('Please register/login', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(user: widget.user))).then((value) => setState((){_loadCart();}));
                }),
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          key: refreshKey,
          color: Colors.pinkAccent,
          onRefresh: () async {
            await refreshList();
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: screenHeight / 12.5,
                      margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            flex: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  shape: BoxShape.rectangle,
                                  border:
                                      Border.all(color: Colors.transparent)),
                              child: TextField(
                                textInputAction: TextInputAction.go,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                autofocus: false,
                                onSubmitted: (_foodController) {
                                  _sortFoodbyName(_foodController.toString());
                                },
                                controller: _foodController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Food...',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: IconButton(
                              color: Colors.blueAccent,
                              icon: Icon(Icons.keyboard_arrow_right),
                              onPressed: () =>
                                  {_sortFoodbyName(_foodController.text)},
                            ),
                          )
                          /*  Flexible(
                            child: MaterialButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side:
                                      BorderSide(color: Colors.lightBlue[600])),
                              onPressed: () =>
                                  {_sortFoodbyName(_foodController.text)},
                              elevation: 5,
                              child: Text('Search foods',
                                  style:
                                      TextStyle(color: Colors.lightBlue[600])),
                            ),
                          )*/
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortFood("Recent"),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.notifications_active,
                                          color: Colors.blue[300],
                                          size: 35,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortFood("Popular"),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.blue[300],
                                          size: 35,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortFood("Price"),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.blue[300],
                                          size: 35,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortFood("Recent"),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.history,
                                          color: Colors.blue[300],
                                          size: 35,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Divider(
                            color: Colors.blueGrey,
                          ),
                        ],
                      )),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          curItem,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Divider(
                            color: Colors.blueGrey,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                itemdata == null
                    ? Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  ProgressDialog pr = new ProgressDialog(
                                      context,
                                      isDismissible: true);
                                  pr.style(message: "Loading");
                                  pr.show();
                                  _loadDate();
                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    pr.hide().whenComplete(() {
                                      print(pr.isShowing());
                                    });
                                  });
                                },
                                child: Icon(
                                  MdiIcons.reload,
                                  color: Colors.grey,
                                )),
                            Container(
                              child: Center(
                                child: Text(titlecenter,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 22,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / screenHeight) / 0.37,
                          children: List.generate(itemdata.length, (index) {
                            return Container(
                              decoration:
                                  BoxDecoration(shape: BoxShape.rectangle),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15)),
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => _onFoodDetail(
                                              itemdata[index]['foodid'],
                                              itemdata[index]['foodname'],
                                              itemdata[index]['foodshop'],
                                              itemdata[index]['price'],
                                              itemdata[index]['quantity'],
                                              itemdata[index]['available'],
                                              itemdata[index]['foodrating'],
                                              itemdata[index]['foodtime'],
                                              itemdata[index]['foodimage'],
                                              itemdata[index]['foodowner'],
                                              itemdata[index]['address']),
                                          child: Container(
                                            height: screenHeight / 4.5,
                                            width: screenWidth / 1.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: server +
                                                  "/images/${itemdata[index]['foodimage']}.jpg",
                                              placeholder: (context, url) =>
                                                  new Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                itemdata[index]['foodname'],
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    letterSpacing: 0.3),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'RM ',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        itemdata[index]['price']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "From " + itemdata[index]['foodshop'],
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.grey[700]),
                                        ),
                                        itemdata[index]['foodrating'] == '0'
                                            ? Row(
                                                children: <Widget>[
                                                  Icon(Icons.star_border,
                                                      color: Colors.amber),
                                                      Text(' (0)')
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Icon(Icons.star,
                                                        color: Colors.amber),
                                                    Text(itemdata[index]
                                                        ['foodrating'])
                                                  ]),
                                                ],
                                              ),
                                              
                                      ],
                                    )),
                              ),
                            );
                          }),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
      /*   floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(user:widget.user)));
        },
        label: Text(
              widget.user.quantity,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ) ??
            Text("0"),
        icon: Icon(MdiIcons.cart),
        backgroundColor: Colors.blueAccent,
      ),*/
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadDate();
    return null;
  }

  Widget _viewFood(int index) {
    print(index);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Text("the food is ${itemdata[index]['foodname']}"),
      ),
    );
  }

  void _loadDate() async {
    String urlLoadFoods = server + "/php/load_food.php";
    await http.post(urlLoadFoods, body: {}).then((res) {
      if (res.body == "nodata") {
        titlecenter = "No food available.";
        setState(() {
          itemdata = null;
        });
      } else {
        print('enter got data');
        print(res.body);
        setState(() {
          var extractdata = json.decode(res.body);
          itemdata = extractdata["food"];
          curItem = "Recent";
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _sortFood(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          isDismissible: true, type: ProgressDialogType.Normal);
      pr.style(message: "Loading...");
      pr.show();
      String urlLoadFood = server + "/php/load_food.php";
      http.post(urlLoadFood, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            itemdata = null;
            curItem = type;
            titlecenter = "No food found.";
          });
          Future.delayed(Duration(seconds: 2)).then((value) {
            pr.hide().whenComplete(() {
              print(pr.isShowing());
            });
          });
        } else {
          setState(() {
            curItem = type;
            var extraction = json.decode(res.body);
            itemdata = extraction["food"];
            FocusScope.of(context).requestFocus(new FocusNode());
            Future.delayed(Duration(seconds: 2)).then((value) {
              pr.hide().whenComplete(() {});
            });
          });
        }
      });
    } catch (e) {
      Toast.show("error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _sortFoodbyName(String foodname) {
    try {
      print(foodname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();

      String urLoadFoods = server + "/php/load_food.php";
      http
          .post(urLoadFoods, body: {
            "name": foodname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Food not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No food found.";
                curItem = "Result:Search for" + "'" + foodname + "'";
                itemdata = null;
                Future.delayed(Duration(seconds: 1)).then((value) {
                  pr.hide().whenComplete(() {
                    print(pr.isShowing());
                  });
                });
              });
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            } else {
              print("gotdata");
              setState(() {
                var extractdata = json.decode(res.body);
                itemdata = extractdata["food"];
                FocusScope.of(context).requestFocus(new FocusNode());
                curItem = "Result:Search for " + "'" + foodname + "'";
                print('helo' + itemdata.toString());
                Future.delayed(Duration(seconds: 1)).then((value) {
                  pr.hide().whenComplete(() {
                    print(pr.isShowing());
                  });
                });
              });
              pr.hide();
              return;
            }
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _onFoodDetail(itemdata, itemdata2, itemdata3, itemdata4, itemdata5, itemdata6,
      itemdata7, itemdata8, itemdata9, itemdata10,itemdata11) {
    Food food = new Food(
        id: itemdata,
        name: itemdata2,
        shopname: itemdata3,
        price: itemdata4,
        quantity: itemdata5,
        available: itemdata6,
        rating: itemdata7,
        regdate: itemdata8,
        foodimage: itemdata9,
        fowner: itemdata10,
        faddress: itemdata11);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoodDetail(
                  user: widget.user,
                  food: food,
                )));
  }

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.user.quantity != "0") {
      _visible = true;
    }
  }

  void _loadCart() async {
    String urlLoadCart = server + "/php/load_cart.php";
    if (widget.user.name == 'unregistered') {
      return;
    }
    http.post(urlLoadCart, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      if (res.body == "Cart Empty") {
        widget.user.quantity = "0";

        return;
      }

      setState(() {
        var extractdata = json.decode(res.body);
        itemCart = extractdata["cart"];
        for (int i = 0; i < itemCart.length; i++) {
          _quantityc = int.parse(itemCart[i]['cquantity']) + _quantityc;
        }
        widget.user.quantity = _quantityc.toString();

        //_amountPayable = _totalPrice + double.parse(_deliveryCharge);
        return;
      });
    }).catchError((err) {
      print(err);
    });
  }
}
