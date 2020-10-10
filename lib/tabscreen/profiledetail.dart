import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fypv1/user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'profilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fypv1/login.dart';

String titleCase(String text) {
  if (text == null) throw ArgumentError("string: $text");

  if (text.isEmpty) return text;

  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

class ProfileDetail extends StatefulWidget {
  final User user;

  const ProfileDetail({Key key, this.user}) : super(key: key);

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _pw = new TextEditingController();
  String server = "http://lawlietaini.com/hewdeliver";
  int _attempt = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Privacy',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen(user: widget.user,)));
            });
          },
          icon: Icon(
            Icons.backspace,
            color: Colors.grey[800],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                // padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      widget.user.email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Flexible(
                        child: Icon(
                      Icons.verified_outlined,
                      color: Colors.blue,
                    ))
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: InkWell(
                  onTap: _changeName,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        size: 25,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        'Change your name',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: InkWell(
                  onTap: _changePassword,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.lock_outline,
                          size: 25, color: Colors.blueGrey),
                      Text(
                        'Change your password',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: InkWell(
                  onTap: _changePhone,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone_android,
                          size: 25, color: Colors.blueGrey),
                      Text(
                        'Change your phone',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: InkWell(
                  onTap: _changeAddress,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 25, color: Colors.blueGrey),
                      Text(
                        'Change your address',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  void _changePhone() {
    TextEditingController _ph =
        new TextEditingController(text: widget.user.phone);
    if (widget.user.name == "no register") {
      Toast.show("Not allowed, please login", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.phone_iphone,
                  color: Colors.blueAccent,
                ),
                Text('Change phone'),
              ],
            ),
            content: new TextField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              controller: _ph,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    if (_ph.text.length < 5) {
                      Toast.show('Please use correct format', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    if (!isValidPhone(_ph.text)) {
                      Toast.show("Invalid phone format", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }
                    http.post(server + "/php/update_profile.php", body: {
                      "email": widget.user.email,
                      "phone": _ph.text,
                    }).then((res) {
                      if (res.body == 'success') {
                        print('success chg');
                        setState(() {
                          widget.user.phone = _ph.text;
                        });
                        Toast.show('Success', context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.of(context).pop();
                        return;
                      } else {}
                    }).catchError((err) {
                      print(err);
                    });
                  },
                  child: Text('Submmit')),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back'))
            ],
          );
        });
  }

  void _changeName() {
    TextEditingController _name =
        new TextEditingController(text: widget.user.name);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Row(
                children: <Widget>[
                  Text('Change name'),
                  Icon(Icons.person_outline, color: Colors.blueAccent)
                ],
              ),
              content: new TextField(
                maxLength: 60,
                keyboardType: TextInputType.text,
                controller: _name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      if (_name.text.length < 6) {
                        Toast.show('Username at least more than 5', context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      }
                      http.post(server + '/php/update_profile.php', body: {
                        'email': widget.user.email,
                        'name': _name.text
                      }).then((res) {
                        if (res.body == 'success') {
                          print('success chg');
                          setState(() {
                            widget.user.name = titleCase(_name.text);
                          });
                          Toast.show('Success', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          Navigator.of(context).pop();
                          return;
                        } else {}
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Text('Submit')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Back'))
              ],
            ));
  }

  void _changePassword() {
    TextEditingController _pass1 = new TextEditingController();
    TextEditingController _pass2 = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Row(
                children: <Widget>[
                  Text('Change password'),
                  Icon(
                    Icons.lock,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _pass1,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Enter old Password',
                        icon: Icon(Icons.lock)),
                  ),
                  TextField(
                    controller: _pass2,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Enter new Password',
                        icon: Icon(Icons.lock)),
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => _updatePassword(_pass1.text, _pass2.text),
                    child: Text('Yes')),
                new FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text('Back'))
              ],
            ));
  }

  _updatePassword(String pass1, String pass2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (pass1 == "" || pass2 == "") {
      Toast.show('Please enter your password', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      print(res.body);
      if (res.body == 'success') {
        print('success chg');
        setState(() {});
        Toast.show('Success changed', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        prefs.setString('email', '');
        prefs.setString('pass', '');
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      } else {
        Toast.show('Failed to change.', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _attempt--;
        if (_attempt == 0) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Forgot password?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    content: Text(''),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {}, child: Text('Find password')),
                      new FlatButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          child: Text('Back')),
                    ],
                  ));
        }
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _changeAddress() {
    TextEditingController _address =
        new TextEditingController(text: widget.user.address);

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Change address'),
              content: TextField(
                controller: _address,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      http.post(server + "/php/update_profile.php", body: {
                        "email": widget.user.email,
                        "address": _address.text
                      }).then((res) {
                        if (res.body == 'success') {
                          print('success chg');
                          setState(() {
                            widget.user.address = _address.text;
                          });
                          Toast.show('Success changed.', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          Navigator.of(context).pop();
                          return;
                        } else {}
                      }).catchError((err) {
                        print(err);
                      });
                    },
                    child: Text('Submit')),
                new FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text('Back'))
              ],
            ));
  }

  bool isValidPhone(String phone) {
    return RegExp(r"^0\d{9,10}").hasMatch(phone);
  }
}
