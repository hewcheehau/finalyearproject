import 'package:flutter/material.dart';
import 'package:fypv1/main.dart';
import 'package:fypv1/tabscreen/provider.dart';
import 'package:fypv1/user.dart';
import 'package:fypv1/food.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class FoodSellDetail extends StatefulWidget {
  final User user;
  final Food food;

  const FoodSellDetail({Key key, this.user, this.food}) : super(key: key);

  @override
  _FoodSellDetailState createState() => _FoodSellDetailState();
}

class _FoodSellDetailState extends State<FoodSellDetail> {
  String server = "http://lawlietaini.com/hewdeliver";

  String _takephoto = "Upload your food product photo";
  final _focus0 = FocusNode();
  final _focus1 = FocusNode();
  final _focus2 = FocusNode();
  final _focus3 = FocusNode();
  final _focus4 = FocusNode();

  TextEditingController fname = new TextEditingController();
  TextEditingController ftype = new TextEditingController();
  TextEditingController faddress = new TextEditingController();
  TextEditingController fprice = new TextEditingController();
  TextEditingController fquantity = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fname = new TextEditingController(text: widget.food.name);
    ftype = new TextEditingController(text: widget.food.description);
    faddress = new TextEditingController(text: widget.food.shopname);
    fprice = new TextEditingController(text: widget.food.price);
    fquantity = new TextEditingController(text: widget.food.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text(
          widget.food.name,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              tooltip: 'Delete this product forever',
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: _onDeleteProduct)
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: CachedNetworkImage(
                        imageUrl:
                            server + "/images/${widget.food.foodimage}.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error_outline, size: 65.0),
                      ),
                      height: 250,
                      width: 250,
                      //  width: double.infinity,
                    ),
                    RaisedButton.icon(
                        color: Colors.blue[100],
                        onPressed: () {},
                        icon: Icon(Icons.linked_camera),
                        label: Text('Edit food photo')),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 7.0,
                    child: Column(
                      children: <Widget>[
                        Table(
                          defaultColumnWidth: FlexColumnWidth(1.0),
                          children: [
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8.0),
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text('Food Name'),
                              )),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                height: 30,
                                child: TextFormField(
                                  controller: fname,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focus0);
                                  },
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide())),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8.0),
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text('Description'),
                              )),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                height: 30,
                                child: TextFormField(
                                  controller: ftype,
                                  focusNode: _focus0,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focus1);
                                  },
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide())),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8.0),
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text('Food Price(RM)'),
                              )),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                height: 30,
                                child: TextFormField(
                                  controller: fprice,
                                  focusNode: _focus1,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focus2);
                                  },
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide())),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8.0),
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text('Quantity per order'),
                              )),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                height: 30,
                                child: TextFormField(
                                  controller: fquantity,
                                  focusNode: _focus2,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focus3);
                                  },
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide())),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 8.0),
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text('Food Shop Address'),
                              )),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                height: 30,
                                child: TextFormField(
                                  controller: faddress,
                                  focusNode: _focus3,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_focus4);
                                  },
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide())),
                                ),
                              ))
                            ]),
                          ],
                        ),
                        SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 60,
                  width: double.infinity,
                  child: MaterialButton(
                      color: Colors.blueAccent,
                      onPressed: () {},
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.7),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDeleteProduct() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text('Delete this product?'),
              content: Text(
                  'Do you want to delete this item from your product list?'),
              actions: [
                MaterialButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      ProgressDialog pr =
                          new ProgressDialog(context, isDismissible: true);
                      pr.style(message: 'Deleting...');
                      pr.show();
                      http.post(server + "/php/delete_product.php", body: {
                        "email": widget.user.email,
                        "foodid": widget.food.id
                      }).then((res) {
                        print(res.body);

                        if (res.body == "success") {
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            pr.hide().whenComplete(() {
                              print(pr.isShowing());
                            });
                          });
                          setState(() {
                            _showSuccessInfo();
                          });
                        } else {}
                      }).catchError((err) {
                        print(err);
                      });
                    }),
                MaterialButton(
                    child: Text('No'),
                    onPressed: () => {Navigator.of(context).pop(false)})
              ],
            ));
  }

  void _showSuccessInfo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(
                                user: widget.user,
                              )),
                      (route) => false);
                },
              )
            ],
          );
        });
  }
}
