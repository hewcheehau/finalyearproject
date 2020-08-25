import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fypv1/newfood.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
String _currentAddress = "Searching your current location";
Position _currentPosition;

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
  double screenHeight,screenWidth;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
      }
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
       //   backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'FOOD MENU',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueAccent,
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
                          setState(() {
                            _val = newValue;
                            print(_val);
                            if (_val) {
                              _foodAvailable = 'Food shop is available';
                            } else {
                              _foodAvailable = 'Food shop is unavailable';
                            }
                          });
                        },
                        activeColor: Colors.greenAccent[400],
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ],
                  ),
                ),
                Expanded(
                                  child: Container(
                      child: RefreshIndicator(
                        onRefresh: () async {
                      await refreshList();
                    },
                    key: refreshKey,
                    child: Container(
                     
                     
                      child: Column(
                          children: <Widget>[
                            itemdata==null?Flexible(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                   Container(
                                     alignment: Alignment.bottomCenter,
                                     height: 150,
                                     width: 200,
                                     padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                       image: DecorationImage(image:AssetImage('asset/images/nofood.png'),
                                       ),
                                     ),
                                  child: Text('No food in your shop',style: TextStyle(fontSize: 18),),
                                ),
                                OutlineButton(
                                  
                                  child: Text('Add food now',style: TextStyle(fontSize: 18)),
                                  
                                  onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>InsertFood(user: widget.user,)))},),
                               
                              ],)
                            ):Expanded(child: GridView.count(crossAxisCount: 2,mainAxisSpacing:10,
                            childAspectRatio: (screenWidth/screenHeight)/0.37,
                            children:List.generate(itemdata.length, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle
                                ),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight/4.5,
                                          width: screenWidth/1.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle
                                          ),
                                          child: CachedNetworkImage(imageUrl: server+"/images/${itemdata[index]['fooddatefoodowner'].jpg}",
                                          placeholder: (context,url)=>new Container(
                                            height:50,
                                            width:50,
                                            child:Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            
                                          ),errorWidget: (context,url,error)=>new Icon(Icons.error),
                                          
                                          imageBuilder: (context, imageProvider)=>Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image:imageProvider,fit:BoxFit.cover,
                                              ),
                                              shape:BoxShape.rectangle
                                            ),
                                          ),),

                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(itemdata[index]['foodname'],maxLines:1,style:TextStyle(fontWeight:FontWeight.w600,fontSize: 20)),
                                            Text('RM ${itemdata[index]['price']}')
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        
                                      ],
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
        );
      }
    
     Future<Null> refreshList()async {
       await Future.delayed(Duration(seconds: 2));
    
     }
    
      void _getCurrentLocation()async {
          geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best).then((Position position){
            setState(() {
              _currentPosition = position;
            });
            _getAddressFromLatLng();
                      }).catchError((e){
                        print(e);
                      });
                  }
            
              void _getAddressFromLatLng()async {
                try{
                  List<Placemark>p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
                  Placemark place = p[0];

                  setState(() {
                    _currentAddress = "${place.name},${place.locality},${place.postalCode},${place.country}";

                  });
                }catch (e){
                  print(e);
                }
              }

}


