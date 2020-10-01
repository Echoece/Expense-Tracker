/*
ListView(childer: []) and ListView.Builder() are two ways of using listview. Difference is , ListView Children  renders every element on that list, 
even if its not showing on screen. On the other hand Builder only renders the ones which are showing on the screen. So for performance wise builder
is way better to use when list is very long. 
*/

//this class isnt included in the main app, i wrote it as an alternative way to show how ListView.builder works
import 'package:ExpenseTracker/model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListNew extends StatelessWidget {
  final List<Transaction> _userTransaction;

  TransactionListNew(this._userTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        //index starts at zero and tells us which element is processed right now.
        itemBuilder: (context, index) => Card(
            child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1)),
              child: Text(
                //this is very important , here we assigning the double value variable inside the
                // string, we cant simply call $e.amount because its not a string. but if we put it inside
                //a {} we can call functions like e.amount.toString() etc
                '\$ ${_userTransaction[index].amount} ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.purple),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _userTransaction[index].title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMMMd().format(_userTransaction[index].date),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        )),
        itemCount: _userTransaction.length,
        // this itemcount is used to determine how many times the itembuilder function will run. in this case legth is two
        // so the function will run two times. that means two cardview.
      ),
    );
  }
}
