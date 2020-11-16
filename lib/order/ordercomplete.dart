import 'package:flutter/material.dart';
import 'package:fypv1/user.dart';
import 'package:fypv1/order.dart';
import 'package:http/http.dart' as http;

class OrderComplete extends StatefulWidget {
  final User user;
  final Order order;

  OrderComplete({Key key, this.user, this.order}) : super(key: key);

  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  String server = "http://lawlietaini.com/hewdeliver";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Order History Detail"),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Order Id: ${widget.order.orderid}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(6.5)
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        "Food Quantity: ",
                        style: TextStyle(fontSize: 18),
                      )),
                      TableCell(
                          child: Text(
                        "${widget.order.quantity}",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        "Food Name: ",
                        style: TextStyle(fontSize: 18),
                      )),
                      TableCell(
                          child: Text(
                        "${widget.order.ordername}",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        "Total Price: ",
                        style: TextStyle(fontSize: 18),
                      )),
                      TableCell(
                          child: Text(
                        "RM ${widget.order.total}",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ))
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        "Method: ",
                        style: TextStyle(fontSize: 18),
                      )),
                      TableCell(
                          child: Text(
                        "${widget.order.method}" == null ? "COD" : "Credit",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ))
                    ]),
                    
                  ],
                ),
              ),
           /*   MaterialButton(
                  color: Colors.blueAccent,
                  onPressed: () => {_goFinishOrder()},
                  child: Text(
                    'Finish Order',
                    style: TextStyle(color: Colors.white),
                  ))*/
            ],
          ),
        ),
      ),
    );
  }

  _goFinishOrder() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Finsih Order'),
              content: Text('Confirm you have finished the food order.'),
              actions: [
                MaterialButton(onPressed: () {
                  http.post(server+"/php/complete_food.php",body:{

                  }).then((res){

                  } ).catchError((err){
                    print(err);
                  });
                }, child: Text('Yes')),
                MaterialButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text('No')),
              ],
            ));
  }
}
