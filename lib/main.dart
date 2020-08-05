import 'package:flutter/material.dart';
import 'package:fypv1/tabscreen/tabscreen.dart';
import 'package:fypv1/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'tabscreen/tabscreen4.dart';
import 'tabscreen/tabscreen.dart';
import 'tabscreen/tabscreen2.dart';
import 'package:fypv1/tabscreen/tabscreendemo.dart';
import 'tabscreen/cartpage.dart';
import 'package:material_design_icons_flutter/icon_map.dart';


class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}): super(key:key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> tabs;

  int currentTabIndex = 0;
  int count = 0;
  bool _isVisible = false;

  @override
  void initState(){
    super.initState();
    tabs = [
      MainPage(user:widget.user),
      CartPage(user:widget.user),
      TabScreen2(user:widget.user),
       TabScreen4(user:widget.user),
    ];
    
      }
      String $pagetitle = "Walking-distance";
    
      onTapped(int index){
        setState(() {
          currentTabIndex = index;
        });
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: tabs[currentTabIndex],
    
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTapped,
            currentIndex: currentTabIndex,
            backgroundColor:Colors.grey[200],
            selectedItemColor:Colors.lightBlueAccent,
            unselectedItemColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
    
            items: [
              BottomNavigationBarItem(
    
                icon:Icon(Icons.home),
                title:Text("Home")
              ),
              BottomNavigationBarItem(
    
                icon:new Stack(
                  children: <Widget>[
                    new Icon(MdiIcons.cart),
                    Visibility(
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
                            minWidth: 12,
                            maxHeight: 12
                          ),
                          child: new Text("${count}",
                          style: TextStyle(color:Colors.white,fontSize:8),textAlign: TextAlign.center,)
                            
                          ),
                          
                        ),
                    ),
                      
                      
                    
                  ],
                ),title: Text('Cart')),
                
              
               BottomNavigationBarItem(
    
                icon:Icon(Icons.directions_walk),
                title:Text("Delivery")
              ),
               BottomNavigationBarItem(
    
                icon:Icon(Icons.account_circle),
                title:Text("Profile")
              ),
            ],
          ),
        );
      }
    
     
}