import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fypv1/food.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/tabscreen/cartpage.dart';
import 'package:fypv1/main.dart';
import 'dart:async';

class FoodDetail extends StatefulWidget {
  final User user;
  final Food food;
  FoodDetail({Key key, this.user, this.food}) : super(key: key);
  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  final globalKey = GlobalKey<ScaffoldState>();
  String server = "http://lawlietaini.com/hewdeliver";
  //List food = new List();
  int current = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String titlecenter = "Loading...";
  double foodPrice = 0;
  int quantity = 0;
  String cartQuantity = "0";
  String _foodid = "";
  @override
  void initState() {
    super.initState();
    // refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: globalKey,
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: CachedNetworkImage(
                            imageUrl:
                                server + "/images/${widget.food.foodimage}.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.error_outline,
                              size: 65.0,
                            ),
                          ),
                          height: 300,
                          width: double.infinity,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                const Color(0xCC000000),
                                const Color(0x00000000),
                                const Color(0x00000000),
                              ])),
                        ),
                        Positioned(
                          top: 5.0,
                          right: 0.0,
                          left: 0.0,
                          child: AppBar(
                            leading: IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainScreen(user: widget.user)));
                                }),
                            iconTheme:
                                IconThemeData(color: Colors.white, size: 25),
                            centerTitle: true,
                            title: Text(
                              widget.food.name,
                              style: TextStyle(fontSize: 25),
                              maxLines: 3,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: screenHeight / 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Text(
                                                  'FROM ${widget.food.shopname.toUpperCase()}',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Icon(Icons.home,
                                                  color: Colors.blueAccent)
                                            ],
                                          ),
                                          Text(
                                            "at RM " +
                                                "${foodPrice = 1.5 + double.parse(widget.food.price)}",
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Divider(),
                                      Column(
                                        children: [
                                          if (widget.food.rating == '1') ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Review: ',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                              ],
                                            ),
                                          ] else if (widget.food.rating ==
                                              '2') ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Review: ',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                              ],
                                            ),
                                          ] else if (widget.food.rating ==
                                              '3') ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Review: ',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                                Icon(Icons.star_border,
                                                    color: Colors.amber),
                                              ],
                                            ),
                                          ] else if (widget.food.rating ==
                                              '4') ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Review: ',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 20),
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(
                                                  Icons.star_border,
                                                  color: Colors.amber,
                                                )
                                              ],
                                            ),
                                          ] else ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Review: ',
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Icon(Icons.star,
                                                    color: Colors.amber)
                                              ],
                                            ),
                                          ]
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              'Include: 1 x ' + widget.food.name,
                                              style: TextStyle(
                                                  color: Colors.grey))),
                                      SizedBox(height: 10),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              'Location: ' + widget.food.name,
                                              style: TextStyle(
                                                  color: Colors.grey))),
                                      SizedBox(height: 10),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              'Each Order Maximum Quantity: ' +
                                                  widget.food.quantity)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            color: quantity > 0
                                ? Colors.blue[800]
                                : Colors.grey[300],
                            disabledColor: Colors.red,
                            onPressed: () {
                              setState(() {
                                if (quantity > 0) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(MdiIcons.minus)),
                        SizedBox(width: 10),
                        Text(
                          quantity.toString(),
                          style: TextStyle(fontSize: 25, color: Colors.black87),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          color: quantity < int.parse(widget.food.quantity)
                              ? Colors.blue[800]
                              : Colors.grey[300],
                          onPressed: () {
                            setState(() {
                              if (quantity <
                                  double.parse(widget.food.quantity)) {
                                quantity++;
                              }
                            });
                          },
                          icon: Icon(MdiIcons.plus),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            height: screenHeight / 12,
                            minWidth: screenWidth / 1.8,
                            onPressed: () {
                              _addCart(quantity);
                            },
                            color:
                                quantity == 0 ? Colors.grey : Colors.lightBlue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_basket,
                                  color: Colors.white,
                                ),
                                Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    quantity == int.parse(widget.food.quantity)
                        ? Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Maximum is *' + widget.food.quantity,
                              style: TextStyle(color: Colors.red),
                            ))
                        : Text("")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadData() async {
    String urlLoadFood = server + "/php/load_food.php";

    await http.post(urlLoadFood, body: {}).then((res) {
      if (res.body == 'nodata') {
        titlecenter = "Food is not availble";
        setState(() {});
      }
    });
  }

  void _addCart(int q) async {
    int _curstore = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("cquantity", 0);
    _foodid = (prefs.getString("foodid"));

    if (widget.user.email == "unregister@hewdeliver.com" ||
        widget.user.name == 'unregistered') {
      Toast.show("Please Register/Login.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == widget.food.fowner) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  
                title: Text('Fail to add.'),
                actions: [
                  Center(
                    child: MaterialButton(
                        child: Text('OK'),
                        onPressed: () => {Navigator.of(context).pop()}),
                  )
                ],
              ));
      Toast.show("This food is provided by this account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int cquantity = int.parse(widget.food.quantity);
      if (cquantity > 0 && q <= cquantity) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to Cart...");
        pr.show();
        String urlLoadCart = server + "/php/add_cart.php";
        http.post(urlLoadCart, body: {
          "email": widget.user.email,
          "foodid": widget.food.id,
          "quantity": q.toString(),
          "fquantity": widget.food.quantity
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Unable to add into cart.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Future.delayed(Duration(seconds: 2)).then((value) {
              pr.hide().whenComplete(() {
                print(pr.isShowing());
              });

              _clearCartDialog(_foodid);
            });
            return;
          } else {
            List respond = res.body.split(",");
            setState(() async {
              cartQuantity = respond[1];
              _curstore = int.parse(cartQuantity) + _curstore;
              _curstore = (prefs.getInt("cquantity")) + _curstore;
              await prefs.setInt("cquantity", _curstore);
              widget.user.quantity = _curstore.toString();
              await prefs.setString("foodid", widget.food.id);
              quantity = 0;
              final snackBar = SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Added Successfully!'),
                action: SnackBarAction(
                    label: 'Manage Cart',
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(user: widget.user)));
                    }),
              );
              globalKey.currentState.showSnackBar(snackBar);
            });
          }
          Future.delayed(Duration(seconds: 1)).then((value) {
            pr.hide().whenComplete(() {
              print(pr.isShowing());
            });
          });
        }).catchError((err) {
          print(err);
          Future.delayed(Duration(seconds: 2)).then((value) {
            pr.hide().whenComplete(() {
              print(pr.isShowing());
            });
          });
        });
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() {
            print(pr.isShowing());
          });
        });
      } else {
        final snackBar = SnackBar(
          content: Text('Unable to add.'),
          // action: SnackBarAction(label: 'Manage Cart', onPressed: (){}),
        );

        globalKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _clearCartDialog(String _foodid) {
    if ((int.parse(widget.user.quantity) + quantity >=
            int.parse(widget.food.quantity)) &&
        (_foodid == widget.food.id)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                title: new Text("The order quantity is excessive"),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(
                                    user: widget.user,
                                  )));
                    },
                    child: Text('Manage your Cart'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                    'Add this food will delete your current food in cart'),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      Navigator.of(context).pop(false);
                      http.post(server + "/php/delete_cart.php", body: {
                        "email": widget.user.email,
                      }).then((res) {
                        print(res.body);

                        if (res.body == "success") {
                          _addCart(quantity);
                          prefs.setInt("cquantity", 0);
                        } else {
                          Toast.show("Failed to proceed", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Text('Proceed'),
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
}
