import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;

String greeting(String name) {
  var time = DateTime.now().hour;

  if (name != "Unregistered") {
    if (time < 12) {
      return "Morning, " + name;
    } else if (time < 17) {
      return "Afternoon, " + name;
    } else {
      return "Evening, " + name;
    }
  } else {
    return "Not Register user";
  }
}

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user}) : super(key: key);
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
    _scrollController = ScrollController();
    
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
          /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent[700],
          elevation: 2.0,
          onPressed: _onNewFood,
          tooltip: 'Add your new food.', 
          
        ),*/
       
          body: SafeArea(
              child: RefreshIndicator(
            key: refreshKey,
            color: Colors.pinkAccent,
            onRefresh: () async {
              await refreshList();
            },
            child: data == null
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[Container()],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    //step 6: count the data
                    itemCount: data == null ? 1 : data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: media.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent[700],
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                          ),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.lightBlueAccent[400],
                                                Colors.blueAccent[700]
                                              ],
                                              begin: const FractionalOffset(
                                                  1.0, 1.0),
                                              end: const FractionalOffset(
                                                  0.2, 0.2),
                                              tileMode: TileMode.clamp),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                20,
                                          ),
                                          Row(children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, top: 10),
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 15),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  greeting(widget.user.name),
                                                  style: TextStyle(
                                                      color: Colors.grey[100],
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            width: 350,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, 15.0),
                                                    blurRadius: 15.0,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, -10.0),
                                                    blurRadius: 10.0,
                                                  )
                                                ]),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_on,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                              _currentAddress),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Center(
                                            child: Text(
                                              "Available food Today",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[850]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      if (index == data.length && perpage > 1) {
                        return Container(
                          width: 250,
                          color: Colors.white,
                          child: MaterialButton(
                            child: Text(
                              "Load more",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                        );
                      }

                      index -= 1;
                      return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Card(
                            margin: const EdgeInsets.all(15),
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(23))),
                            child: InkWell(
                              onTap: () => () {},
                              /* _onFoodDetail(
                                                                    data[index]['foodid'],
                                                                    data[index]['foodimage'],
                                                                    data[index]['foodtime'],
                                                                    data[index]['price'],
                                                                    data[index]['quantity'],
                                                                    data[index]['foodowner'],
                                                                    data[index]['foodshop'],
                                                                    data[index]['itemlatitude'],
                                                                    data[index]['itemlongitude'],
                                                                    data[index]['available'],
                                                                    ),*/
                              onLongPress: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Image.network(
                                        "http://lawlietaini.com/hewdeliver/images/${data[index]['foodid']}.jpg",
                                        height: 150,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    data[index]['foodname']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  SizedBox(width:30),
                                                  Icon(Icons.star),
                                                  Expanded(
                                                                                                      child: Container(
                                                      child: Text('Review',
                                                      maxLines: 2,
                                                      style: TextStyle(),),
                                                    ),
                                                  )
                                                  
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.attach_money,
                                                    color: Colors
                                                        .lightBlueAccent[400],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("RM ${data[index]['price']}", style: TextStyle(fontSize:20),),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.restaurant,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    data[index]['foodshop'],
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 100,
                                          child: VerticalDivider(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: <Widget>[
                                              Icon(
                                                Icons.chevron_right,
                                                size: 45,
                                                color: Colors.black45,
                                              ),
                                            ],
                                          ),
                                        )
                                        /* Container(
                                                                      height: 130,
                                                                      width: 100,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.rectangle,
                                                                          border: Border.all(color: Colors.white),
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.fill,
                                                                              image: NetworkImage(
                                                                                  "http://lawlietaini.com/myrecycle_user/images/${data[index]['itemimage']}.jpg"))),
                                                                    ),*/
                                        /*  Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                      
                                                                        
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            Text(
                                                                                data[index]['itemtitle']
                                                                                    .toString()
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold)),
                                                                            RatingBar(
                                                                                itemCount: 5,
                                                                                itemSize: 12,
                                                                                initialRating: double.parse(
                                                                                    data[index]['itemrating']
                                                                                        .toString()),
                                                                                itemPadding: EdgeInsets.symmetric(
                                                                                    horizontal: 2.0),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.teal[700],
                                                                                    )),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Icon(Icons.phone),
                                                                            Text(data[index]['itemphone']),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Text(data[index]['itemtime']),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            Icon(
                                                                              Icons.chevron_right,
                                                                              size: 45,
                                                                              color: Colors.black45,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
          )),
        
      ),
    );
  }

  void _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void _onNewFood() {}

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.locality},${place.postalCode},${place.country}";

        //load data from database into list array 'data'
        init();
      });
    } catch (e) {
      print(e);
    }
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  Future<String> makeRequest() async {
    String urlLoadItems = "http://lawlietaini.com/hewdeliver/php/load_food.php";

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Loading foods');
    //pr.show();
     
    http.post(urlLoadItems, body: {
      "email": widget.user.email ?? "notvail",
      "latitude": _currentPosition.latitude.toString() ?? "notvail",
      "longtidue": _currentPosition.longitude.toString() ?? "notvail",
    }).then((res) {
      print('enter load');
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["food"];
        perpage = (data.length / 10);
        print('data???');
        print(data);
       
         

      });
      
    }).catchError((err) {
      print(err);
      pr.hide();
    });
     
    return null;
  }

  _onFoodDetail(data, data2, data3, data4, data5, data6, data7, data8, data9,
      data10, points, String name, String credit) {}
}
