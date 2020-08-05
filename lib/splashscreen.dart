import 'package:flutter/material.dart';
import 'login.dart';

void main() =>runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen() ,
  )
);

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Column(
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
        )
      ),
    );
  }
}
class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> 
  with SingleTickerProviderStateMixin{
    AnimationController controller;
    Animation<double> animation;
  
  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000), vsync: this);
      animation = Tween(begin:0.0, end: 1.0).animate(controller)..addListener(() {
        setState(() {
          if(animation.value>0.99) {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LoginScreen()));
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
}