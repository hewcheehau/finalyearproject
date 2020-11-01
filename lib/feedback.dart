import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

final df = new DateFormat('dd-MM-yyyy hh:mm a');
DateTime dateTime;

class FeedBackScreen extends StatefulWidget {
  final User user;

  FeedBackScreen({Key key, this.user}) : super(key: key);

  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  String server = "http://lawlietaini.com/hewdeliver";
  String titlecenter = "Loading order history...";
  List itemhistory;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        
        alignment: Alignment.center,
        child: Column(
          children: [
            itemhistory == null
                ? Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        titlecenter,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: (screenHeight / screenWidth / 1.27),
                      children: List.generate(itemhistory.length, (index) {
                        return Container(
                          
                          decoration: BoxDecoration(shape: BoxShape.rectangle),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: InkWell(
                                  onTap: () => {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: screenHeight / 4.5,
                                          width: screenWidth / 1.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle),
                                          child: CachedNetworkImage(
                                            imageUrl: server +
                                                "/images/${itemhistory[index]['foodimage']}.jpg",
                                            placeholder: (context, url) =>
                                                new Container(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
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
                                                  shape: BoxShape.rectangle),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text("${itemhistory[index]['foodname']}"),
                                      Text("RM ${itemhistory[index]['price']}"),
                                      Text(
                                          "${dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(itemhistory[index]['date'])}"),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _loadHistory() {
    http.post(server + "/php/get_history.php", body: {
      'email': widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == 'nohistory') {
        Toast.show('No record', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        titlecenter = "No order history found";
        itemhistory = null;
        setState(() {});
      } else {
        var extraction = json.decode(res.body);
        itemhistory = extraction["history"];
        setState(() {});
      }
    }).catchError((err) {
      print(err);
    });
  }
}
