import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'main.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

String _email, _pw;
String server = "http://lawlietaini.com/hewdeliver";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'asset/images/logofyp.png',
            width: 250,
            height: 250,
          ),
          SizedBox(
            height: 18,
          ),
          new ProgressIndicator(),
        ],
      )),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            _loadpref(this.context);
           // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new CircularProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  void _loadpref(BuildContext ctx) async {
    print('Inside loadpref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _pw = (prefs.getString('pass'));
    print("Splash:Preference");
    print(_email);
    print(_pw);
    if (_isEmailValid(_email)&&_pw.length>5) {
      _onLogin(_email, _pw, ctx);
    } else {
      User user = new User(
          name: "unregistered",
          email: "user@noregisterwaklingdeliver.com",
          phone: "unregistered",
          type: "unregistered",
          credit: "unregistered",
          address: "unregistered",
          datereg: "unregistered",
          quantity: "0");
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _onLogin(String email, String pw, BuildContext ctx) {
    http.post(server + "/php/get_user.php", body: {
      "email": _email,
      "password": _pw,
    }).then((res) {
      print(res.statusCode);
      var extraction = res.body;
      List extract = extraction.split(",");
      print("SplashScreen:Loading");

      if (extract[0] == "success") {
        User user = new User(
            name: extract[1],
            email: extract[2],
            phone: extract[3],
            type: extract[4],
            credit: extract[5],
            datereg: extract[6],
            address: extract[7],
            quantity: "0");
        Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      user: user,
                    )));
      } else {
        //allow user login as unregister user
        print("no register");
        User user = new User(
            name: "unregistered",
            email: "user@noregisterwaklingdeliver.com",
            phone: "unregistered",
            type: "unregistered",
            credit: "unregistered",
            address: "unregistered",
            datereg: "00-00-0000",
            quantity: "0");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(user:user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
