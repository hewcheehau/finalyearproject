import 'package:flutter/material.dart';
import 'package:fypv1/payment.dart';
import 'package:intl/intl.dart';
import 'user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fypv1/checkreg.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';

final _amountValidator =
    RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
final TextEditingController _amount = TextEditingController();

class CreditInfo extends StatefulWidget {
  final User user;

  CreditInfo({Key key, this.user}) : super(key: key);

  @override
  _CreditInfoState createState() => _CreditInfoState();
}

class _CreditInfoState extends State<CreditInfo> {
  String server = "http://lawlietaini.com/hewdeliver";
  List itemcredit;
  String titlecenter = "Loading credit...";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this._loadCredit();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          title: Text(
            'My Credit',
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius:
                  new BorderRadius.vertical(bottom: new Radius.circular(30))),
          centerTitle: true,
          backgroundColor: Colors.blueAccent[400],
          leading: IconButton(
              icon: Icon(
                Icons.backspace_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                _amount.text = "";
                Navigator.of(context).pop(true);
              }),
          bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50))),
              height: 70,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.currencyUsd,
                        color: Colors.white,
                      ),
                      Text(
                        "${widget.user.credit}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(4),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            itemcredit == null
                ? Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [Text(titlecenter)],
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisCount: 1,
                      childAspectRatio: (screenWidth / screenHeight) / 0.37,
                      children: List.generate(itemcredit.length, (index) {
                        return Container(
                          
                          decoration: BoxDecoration(

                          
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              itemcredit[index]['status'] == 'credit'
                                  ? Row(
                                      children: [
                                         Icon(Icons.add,color: Colors.green,),
                                        Text('RM ${itemcredit[index]['total']}'),
                                        
                                       
                                      ],
                                    )
                                  : Row(
                                      children: [
                                         Icon(Icons.remove,color: Colors.redAccent,),
                                        Text('RM ${itemcredit[index]['total']}'),
                                          
                                       
                                      ],
                                    )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BuyCredit(user: widget.user,)))
              },
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.plus,
                      color: Colors.white,
                    ),
                    Text(
                      'Buy credit',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadCredit() {
    http.post(server + "/php/load_credit.php",
        body: {'email': widget.user.email}).then((res) {
      if (res.body == 'nodata') {
        itemcredit = null;
        titlecenter = "No record";
        setState(() {});
      } else {
        print(res.body);
        var extraction = json.decode(res.body);
        itemcredit = extraction["credit"];
        print(itemcredit);
        setState(() {});
      }
    }).catchError((err) {
      print(err);
    });
  }
}

class BuyCredit extends StatefulWidget {
  final User user;

  BuyCredit({Key key, this.user}) : super(key: key);

  @override
  _BuyCreditState createState() => _BuyCreditState();
}

class _BuyCreditState extends State<BuyCredit> {
  List _select = ['10', '20', '50', '100', '200'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Credit Top Up',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.backspace,
              color: Colors.blueAccent,
            ),
            onPressed: () => {Navigator.of(context).pop(true)}),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'RM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: _amount,
                      inputFormatters: [_amountValidator],
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration:
                          InputDecoration(hintText: 'Enter Top Up Amount'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 5,
                  children: List.generate(5, (index) {
                    return Container(
                      child: Container(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          _amount.text = _select[index];
                        },
                        child: Text("${_select[index]}"),
                      )),
                    );
                  })),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: MaterialButton(
                  minWidth: double.infinity,
                  color: _amount.text == null ? Colors.grey : Colors.blueAccent,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text('Confirm your payment'),
                              content: Text('Are you sure to buy?'),
                              actions: [
                                MaterialButton(onPressed: (){
                                  String _method = 'DCP';
                                  String _orderid = generateOrderid();
                                  String _val = _amount.text;
                                  if(_amount.text==''){
                                    Toast.show('Please enter amount', context,duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
                                    return;
                                  }
                                  if(double.parse(_amount.text) <=5){
                                    Toast.show('Minimum amount RM5', context,duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
                                    return;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen(user:widget.user,methodpay: _method,orderid: _orderid,val: _val,)));
                                },
                                child:Text('Yes, buy',style: TextStyle(color:Colors.blue),)),
                                MaterialButton(onPressed: ()=>{Navigator.of(context).pop()},child:Text('No',style: TextStyle(color:Colors.red),))
                              ],
                            ));
                  },
                  child: Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

   String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    return orderid;
  }
}
