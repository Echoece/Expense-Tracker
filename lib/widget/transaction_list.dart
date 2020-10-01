import 'package:ExpenseTracker/model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function _deleteTransaction;

  TransactionList(this._userTransaction, this._deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: _userTransaction.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Data Yet',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * .6,
                    child: Image.asset(
                      'Assets/Image/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          //better use Listview builder, its better
          : ListView(
              children: (_userTransaction).map((e) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    //leading is element at first, this is spent amount
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '\$${e.amount.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //title is 2nd element, this is the item name
                    title: Text(
                      e.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(DateFormat.yMMMMd().format(e.date)),
                    // we could add  a trailing element here, which is the end element. usually we use it to
                    // put disposable button like delete etc

                    // the eternary expression checks if we have available width to put in some extra info.
                    trailing: MediaQuery.of(context).size.width > 460
                        ? FlatButton.icon(
                            textColor: Theme.of(context).errorColor,
                            onPressed: () => _deleteTransaction(e.id),
                            icon: Icon(Icons.delete),
                            label: Text('Delete'))
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => _deleteTransaction(e.id),
                          ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

/*
after ListView usertransaction map, old code. replaced it with ListTile(). the below view have box border around the amount 
Card(
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
                        //a {} we can call functions like e.amount.toString() etc. here tostringAsFixed(2)  means 2 decimal will be shown
                        '\$ ${e.amount.toStringAsFixed(2)} ',
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
                          e.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.yMMMd().format(e.date),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ))

*/
