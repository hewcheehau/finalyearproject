import 'package:flutter/material.dart';
import 'package:fypv1/tabscreen/trymap.dart';
import 'package:fypv1/user.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/newfood.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fypv1/newproduct.dart';
import 'package:fypv1/food.dart';
import 'package:fypv1/food/foodseller.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
String _currentAddress = "Searching your current location";
Position _currentPosition;
enum _foodset { hard, www, wwww, wwwwww }

class ProviderScreen extends StatefulWidget {
  final User user;

  const ProviderScreen({Key key, this.user}) : super(key: key);

  @override
  _ProviderScreenState createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List itemdata;
  String server = "http://lawlietaini.com/hewdeliver";
  bool _val = false;
  String _foodAvailable = 'Food shop is unavailable';
  double screenHeight, screenWidth;
  String _isFood = "";
  String titlecenter = "Getting your food...";
  bool _isSelected = true;
  bool _isAvailable = false;
  List<bool> listcheck = new List<bool>();

  void _radio() {
    setState(() {
      // _isSelected = !_isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
    _loadData();
   
      }
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'FOOD MENU',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(_foodAvailable,
                              style:
                                  TextStyle(color: Colors.black87, fontSize: 20))),
                      Switch(
                        value: _val,
                        onChanged: (newValue) {
                          try {
                            ProgressDialog pr = new ProgressDialog(context,
                                isDismissible: true,
                                type: ProgressDialogType.Normal);
                            pr.style(message: "Updating restaurant status...");
                            pr.show();
                            setState(() {
                              _val = newValue;
                              print(_val);
                              if (_val) {
                                _foodAvailable = 'Food shop is available';
                              } else {
                                _foodAvailable = 'Food shop is unavailable';
                              }
                              String _isAvailable =
                                  server + "/php/load_foodprovide.php";
                              http.post(_isAvailable, body: {
                                'email': widget.user.email,
                                'setfood': _foodAvailable
                              }).then((res) {
                                if (res.body == 'nodata') {
                                  setState(() {
                                    Toast.show('Failed to change', context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                    titlecenter = "No food found";
                                  });
                                } else {
                                  Toast.show('Status changed', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                                Future.delayed(Duration(seconds: 2)).then((value) {
                                  pr.hide().whenComplete(() {
                                    print(pr.isShowing());
                                  });
                                });
                              });
                            });
                          } catch (e) {
                            Toast.show("error", context,
                                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        },
                        activeColor: Colors.greenAccent[400],
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Set available food',
                              style: TextStyle(fontSize: 20),
                            ),
                            FlatButton.icon(
                                onPressed: () => {_chooseAvailablefood()},
                                icon: Icon(Icons.arrow_forward_ios),
                                label: Text('Click'))
                          ],
                        ))),
                Divider(
                  color: Colors.grey,
                ),
                Expanded(
                  child: Container(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      await refreshList;
                    },
                    key: refreshKey,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          itemdata == null
                              ? Flexible(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      height: 150,
                                      width: 200,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage('asset/images/nofood.png'),
                                        ),
                                      ),
                                      child: Text(
                                        titlecenter,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    OutlineButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      child: Text('Add food now',
                                          style: TextStyle(fontSize: 18)),
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => InsertFood(
                                                      user: widget.user,
                                                    )))
                                      },
                                    ),
                                  ],
                                ))
                              : Expanded(
                                  child: GridView.count(
                                      crossAxisCount: 2,
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      mainAxisSpacing: 12.0,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio:
                                          (screenWidth / screenHeight) / 0.47,
                                      children:
                                          List.generate(itemdata.length, (index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle),
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: InkWell(
                                                onTap: ()=>{_onfoodselldetail(itemdata[index]['foodid'],itemdata[index]['foodname'],itemdata[index]['foodshop'],itemdata[index]['price'],itemdata[index]['quantity'],itemdata[index]['available'],itemdata[index]['foodrating'],itemdata[index]['fooddate'],itemdata[index]['foodimage'],itemdata[index]['description'])},
                                                  onLongPress: _onDeleteItem,                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child:Container(
                                                          height: screenHeight / 4.5,
                                                          width: screenWidth / 1.0,
                                                          decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape.rectangle),
                                                          child: CachedNetworkImage(
                                                            imageUrl: server +
                                                                "/images/${itemdata[index]['foodimage']}.jpg",
                                                            placeholder:
                                                                (context, url) =>
                                                                    new Container(
                                                              height: 50,
                                                              width: 50,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                new Icon(Icons.error),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      shape: BoxShape
                                                                          .rectangle),
                                                            ),
                                                          ),
                                                        ),
                                                      
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        'Name:',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                                                                                      child: Text(
                                                                itemdata[index]
                                                                    ['foodname'],
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    fontSize: 18)),
                                                          ),
                                                          Text(
                                                              'RM ${itemdata[index]['price']}',
                                                              style: TextStyle(
                                                                  fontSize: 18))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })))
                        ],
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewFood(
                            user: widget.user,
                          )))
            },
            child: Icon(Icons.add),
            tooltip: 'Add new food product to your shop',
            backgroundColor: Colors.blueAccent,
          ),
        );
      }
    
      Future<Null> get refreshList async {
        await Future.delayed(Duration(seconds: 2));
      }
    
      void _getCurrentLocation() async {
        geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
          });
          _getAddressFromLatLng();
        }).catchError((e) {
          print(e);
        });
      }
    
      void _getAddressFromLatLng() async {
        try {
          List<Placemark> p = await geolocator.placemarkFromCoordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          Placemark place = p[0];
    
          setState(() {
            _currentAddress =
                "${place.name},${place.locality},${place.postalCode},${place.country}";
          });
        } catch (e) {
          print(e);
        }
      }
    
      void _loadData() async {
        print('enter load');
        String urlLoadfood = server + "/php/load_foodprovide.php";
        await http
            .post(urlLoadfood, body: {'email': widget.user.email}).then((res) {
          if (res.body == 'nodata') {
            setState(() {
              itemdata = null;
              titlecenter = 'No food product';
            });
          } else {
            print('got data');
            print(res);
            setState(() {
              var extractdata = json.decode(res.body);
              itemdata = extractdata["food"];
               _checkShop();
              _sortList();
            });
          }
        }).catchError((err) {
          print(err);
        });
      }
    
      void _onDeleteItem() {}
    
      _chooseAvailablefood() {
        showDialog(
            context: context,
            builder: (
              BuildContext context,
            ) =>
                StatefulBuilder(builder: (context, setState) {
                  return SimpleDialog(
                    title: Text(
                      'Select available food',
                      style: TextStyle(),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Food Product',
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text('Set Available',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 10,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        child: itemdata==null?Container(
                          alignment: Alignment.center,
                          child: Text('No food in your list.'),
                        ):ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: itemdata.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Column(
                                  children: <Widget>[
                                    Table(
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                              child: Container(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                                "${itemdata[index]['foodname']}"),
                                          )),
                                          TableCell(
                                              child: Container(
                                                  child: CheckboxListTile(
                                                      value: listcheck[index],
                                                      onChanged: (bool newValue) {
                                                        setState(() {
                                                          _checkAvailable(
                                                              newValue, index);
                                                          listcheck[index] =
                                                              newValue;
                                                        });
                                                      })))
                                        ])
                                      ],
                                    ),
                                  ],
                                )),
                              );
                            }),
                      ),
                      OutlineButton.icon(
                        onPressed: () => {Navigator.of(context).pop(false)},
                        icon: Icon(Icons.done),
                        label: Text('Finish edit'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      )
                    ],
                  );
                }));
      }
    
      Widget radioButton(bool isSelected) {
        setState(() {});
        return Container(
            width: 16.0,
            height: 16.0,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2.0, color: Colors.black),
            ),
            child: isSelected
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  )
                : Container());
      }
    
      void _checkAvailable(bool newValue, int n) {
        String setfood;
        if (newValue) {
          setfood = "1";
          print(setfood);
        } else {
          setfood = "0";
          print(setfood);
        }
        setState(() {
          http.post(server + "/php/update_food.php", body: {
            'id': itemdata[n]['foodid'],
            'setfood': setfood,
            'email': widget.user.email
          }).then((res) {
            print(res.body);
            if (res.body == "nodata") {
              Toast.show('failed', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              print('ess');
              _loadData();
            }
          });
        });
      }
    
      void _sortList() {
        listcheck.length = itemdata.length;
        for (int i = 0; i < itemdata.length; i++) {
          if (itemdata[i]['available'] == '1') {
            listcheck[i] = true;
          } else {
            listcheck[i] = false;
          }
        }
      }
    
      _onfoodselldetail(n, n1, n2, n3, n4, n5, n6, n7, n8,n9) {
        Food food = new Food(
            id: n,
            name: n1,
            shopname: n2,
            price: n3,
            quantity: n4,
            available: n5,
            rating: n6,
            regdate: n7,
            foodimage: n8);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodSellDetail(user:widget.user,food:food)));
      }
    
      void _checkShop() {
        for(int i=0; i<itemdata.length-1; i++){
          if(itemdata[i]['available']=="1"){
            _val = true;
          }
        }
      }
}
