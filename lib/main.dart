import 'package:ExpenseTracker/widget/chart.dart';
import 'package:ExpenseTracker/widget/new_transaction.dart';
import 'package:ExpenseTracker/widget/transaction_list.dart';
import 'package:flutter/material.dart';

import 'model/Transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        home: MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          //by default floating action button is configured to use the accentcolor. in case its not available its uses the primaryswatch
          accentColor: Colors.amber,
          fontFamily: 'QuickSand',
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(color: Colors.white)),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () => {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  final List<Transaction> _userTransaction = [
    // Transaction('t1', 'new shoes', 67.7, DateTime.now()),
    // Transaction('t2', 'new dress', 134.6, DateTime.now())
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction
        .where((element) =>
            element.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _deleteTransaction(String idDelete) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == idDelete);
    });
  }

  void _addNewTransaction(
      String txtTitle, double txtAmount, DateTime choosenDate) {
    final newTx = Transaction(
        DateTime.now().toString(), txtTitle, txtAmount, choosenDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Personal Expenses',
            style: TextStyle(fontFamily: 'OpenSans'),
          ),
          elevation: 5,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Chart(_recentTransaction),
              TransactionList(_userTransaction, _deleteTransaction),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
          child: Icon(Icons.add),
        ));
  }
}
