import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fypv1/main.dart';
import 'package:image_cropper/image_cropper.dart';

class NewFood extends StatefulWidget {
  final User user;
  const NewFood({Key key, this.user}) : super(key: key);

  @override
  _NewFoodState createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  String server = "http://lawlietaini.com/hewdeliver";
  final _picker = ImagePicker();
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;
  String pathAsset = 'asset/images/nofood.png';
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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Food',
          style: TextStyle(
              color: Colors.black87, letterSpacing: 0.7, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.cancel,color:Colors.blueAccent), onPressed: ()=>{Navigator.of(context).pop()}),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {_choose()},
                  child: Container(
                    height: screenHeight / 3.5,
                    width: screenWidth / 1.8,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('(Upload your food product photo)'),
                Text('*Required*', style: TextStyle(color: Colors.red)),
                SizedBox(height: 15),
                Container(
                  width: screenWidth / 1.0,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
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
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
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
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  height: 30,
                                  child: Text('Food Price (RM)'),
                                )),
                                TableCell(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                  height: 30,
                                  child: TextFormField(
                                    controller: fprice,
                                    focusNode: _focus1,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_focus2);
                                    },
                                    decoration: new InputDecoration(
                                      hintText: 'Set price',
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
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
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                    keyboardType: TextInputType.numberWithOptions(),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_focus3);
                                    },
                                    decoration: new InputDecoration(
                                      hintText: 'Set max per order',
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
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
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_focus4);
                                    },
                                    decoration: new InputDecoration(
                                        hintText: 'etc: Kachi Mall',
                                        contentPadding:
                                            const EdgeInsets.all(5.0),
                                        border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide())),
                                  ),
                                ))
                              ])
                            ],
                          ),
                          SizedBox(height: 10),
                          MaterialButton(
                              minWidth: screenWidth / 1.5,
                              height: 50,
                              color: Colors.blueAccent,
                              focusNode: _focus4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              onPressed: _addfoodproduct,
                              child: Text(
                                'Save and Upload',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _choose() async {
    showModalBottomSheet(
        context: context,
        builder: (builder) => Container(
              padding: EdgeInsets.all(40),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () async {
                      PickedFile image = await _picker.getImage(
                          source: ImageSource.camera,
                          maxHeight: 400,
                          maxWidth: 300,
                          imageQuality: 80);

                      setState(() {
                        if(image!=null){
                        _image = File(image.path);
                        }
                        //   _cropImage();
                        Navigator.of(context).pop(false);
                      });
                    },
                  ),
                  Divider(thickness: 0, color: Colors.grey[400], indent: 0),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Gallery'),
                    onTap: () async {
                      PickedFile image = await _picker.getImage(
                          source: ImageSource.gallery,
                          maxHeight: 400,
                          maxWidth: 300,
                          imageQuality: 80);
                      setState(() {
                        if(image!=null){
                        _image = File(image.path);
                        }
                        Navigator.of(context).pop(false);
                      });
                    },
                  ),
                ],
              ),
            ));
  }

  void _addfoodproduct() {
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    );
    if(fname.text!=null && faddress.text!=null && fquantity.text!=null && fprice.text!=null){
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(server + "/php/add_food.php", body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "fname": fname.text,
      "fshop": faddress.text,
      "ftype": ftype.text,
      "price": fprice.text,
      "quantity": fquantity.text,
    }).then((res) {
      print(res.statusCode);
      if (res.body == 'success') {
        fname.text = "";
        faddress.text = "";
        ftype.text = "";
        fprice.text = "";
        fquantity.text = "";
        _image = null;

        _showSuccess();
      } else {
        Toast.show('Failed', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
    }else{
      Toast.show('Please complete the form', context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return;
    }
  }

  void _showSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Food uploaded successfully'),
            content: Icon(Icons.check_circle_outline),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                MainScreen(user: widget.user)),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
