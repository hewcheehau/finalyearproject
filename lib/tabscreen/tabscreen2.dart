import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/food/fooddetail.dart';
import 'package:fypv1/splashscreen.dart';
import 'package:fypv1/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:fypv1/food.dart';
import 'package:fypv1/food/fooddetail.dart';

class TabScreen2 extends StatefulWidget {
  final User user;

  const TabScreen2({Key key, this.user}) : super(key: key);

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  GlobalKey<RefreshIndicatorState> refreshKey;

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

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadDate();

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
        title: Text(
          'Today food',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          /*  IconButton(
            icon: _visible
                ? new Icon(Icons.expand_more)
                : new Icon(Icons.expand_less),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          )*/
          IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: null)
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
                            child: Container(
                              height: 30,
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                autofocus: false,
                                controller: _foodController,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.lightBlue,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue[600]),
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: Card(
                    elevation: 10,
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
                                    color: Colors.pinkAccent,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.update,
                                          color: Colors.black87,
                                        ),
                                        Text(
                                          'Recent',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortFood("Popular"),
                                    color: Colors.blueAccent,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(MdiIcons.food),
                                        Text('Popular')
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  curItem,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                itemdata == null
                    ? Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: (){
                                ProgressDialog pr = new ProgressDialog(context,isDismissible: true);
                                pr.style(message: "Loading");
                                pr.show();
                                _loadDate();
                                Future.delayed(Duration(seconds: 2)).then((value){
                                    pr.hide().whenComplete(() {
                                        print(pr.isShowing());
                                        
                                    });
                                });
                                
                               
                              },
                              child: Icon(MdiIcons.reload,color: Colors.grey,)),
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
                          crossAxisCount: 1,
                          childAspectRatio: (screenWidth / screenHeight) / 0.35,
                          children: List.generate(itemdata.length, (index) {
                            return Container(
                              decoration:
                                  BoxDecoration(shape: BoxShape.rectangle),
                              child: Card(
                                elevation: 8,
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              itemdata[index]['foodtime']),
                                          child: Container(
                                            height: screenHeight / 4.5,
                                            width: screenWidth / 1.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: server +
                                                  "/images/${itemdata[index]['foodid']}.jpg",
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
                                        Text(
                                          itemdata[index]['foodname'],
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "Shop: " +
                                              itemdata[index]['foodshop'],
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        itemdata[index]['foodrating'] == '0'
                                            ? Row(
                                                children: <Widget>[
                                                  Icon(Icons.star_border,
                                                      color: Colors.amber)
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text("RM ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Text(
                                                              "${priceFood = 1.5 + double.parse(itemdata[index]['price'])}",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                        /*    Column(
                                                                                    children: [
                                                                                      if (itemdata[index]['foodrating'] ==
                                                                                          '1') ...[
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Review',
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
                                                                                      ] else if (itemdata[index]
                                                                                              ['foodrating'] ==
                                                                                          '2') ...[
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Review',
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
                                                                                      ] else if (itemdata[index]
                                                                                              ['foodrating'] ==
                                                                                          '3') ...[
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Review',
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
                                                                                      ] else if (itemdata[index]
                                                                                              ['foodrating'] ==
                                                                                          '4') ...[
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Review',
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
                                                                                            Icon(
                                                                                              Icons.star_border,
                                                                                              color: Colors.amber,
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ] else ...[
                                                                                        Row(
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              'Review',
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
                                                                                  )*/
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
        print(res);
        setState(() {
          var extractdata = json.decode(res.body);
          itemdata = extractdata["food"];
          
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _sortFood(String s) {}

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
      itemdata7,itemdata8) {
    Food food = new Food(
        id: itemdata,
        name: itemdata2,
        shopname: itemdata3,
        price: itemdata4,
        quantity: itemdata5,
        available: itemdata6,
        rating: itemdata7,
        regdate: itemdata8);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoodDetail(
                  user: widget.user,
                  food: food,
                )));
  }
  
}

