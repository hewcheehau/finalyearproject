import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fypv1/food.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/tabscreen/cartpage.dart';

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

  @override
  void initState() {
    super.initState();
    // refreshKey = GlobalKey<RefreshIndicatorState>();
    //  _loadData();
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
                            imageUrl: server + "/images/${widget.food.id}.jpg",
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.error_outline,
                              size: 65.0,
                            ),
                          ),
                          height: 300,
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
                            centerTitle: true,
                            title: Text(widget.food.name),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                          ),
                        )
                      ],
                    ),

                    //SizedBox(height:10),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: [
                              if (widget.food.rating == '1') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Review: ',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    Icon(Icons.star, color: Colors.amber),
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
                              ] else if (widget.food.rating == '2') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Review: ',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star_border,
                                        color: Colors.amber),
                                    Icon(Icons.star_border,
                                        color: Colors.amber),
                                  ],
                                ),
                              ] else if (widget.food.rating == '3') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Review: ',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star_border,
                                        color: Colors.amber),
                                    Icon(Icons.star_border,
                                        color: Colors.amber),
                                  ],
                                ),
                              ] else if (widget.food.rating == '4') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Review: ',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(
                                      Icons.star_border,
                                      color: Colors.amber,
                                    )
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Review: ',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber),
                                    Icon(Icons.star, color: Colors.amber)
                                  ],
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: 8),
                          Card(
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
                                            Icon(
                                              Icons.restaurant,
                                              color: Colors.blueAccent,
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Text(
                                                '${widget.food.shopname.toUpperCase()}',
                                                style: TextStyle(
                                                    color: Colors.blue[600],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Icon(Icons.home, color: Colors.blue)
                                          ],
                                        ),
                                        Text(
                                          "at RM " +
                                              "${foodPrice = 1.5 + double.parse(widget.food.price)}",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'Include: 1x' + widget.food.name,
                                            style:
                                                TextStyle(color: Colors.grey))),
                                    SizedBox(height: 10),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'Location: ' + widget.food.name,
                                            style:
                                                TextStyle(color: Colors.grey))),
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
                            height: screenHeight / 12,
                            minWidth: screenWidth / 1.8,
                            onPressed: () {
                              _addCart(quantity);
                            },
                            color:
                                quantity == 0 ? Colors.grey : Colors.lightBlue,
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
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

  void _addCart(int q) {
    if (widget.user.email == "unregister@hewdeliver.com") {
      Toast.show("Please Register/Login.", context,
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
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Unable to add into cart.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Future.delayed(Duration(seconds: 2)).then((value) {
              pr.hide().whenComplete(() {
                print(pr.isShowing());
              });
            });
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartQuantity = respond[1];
              widget.user.quantity = cartQuantity;
              quantity = 0;
              final snackBar = SnackBar(
              duration: Duration(seconds:2),
              content: Text('Added Successfully!'),
              action: SnackBarAction(label: 'Manage Cart', onPressed: () {
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CartPage(user:widget.user)));
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
}
