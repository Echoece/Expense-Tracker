import 'dart:io';

import 'package:ExpenseTracker/widget/chart.dart';
import 'package:ExpenseTracker/widget/new_transaction.dart';
import 'package:ExpenseTracker/widget/transaction_list.dart';
import 'package:flutter/material.dart';

import 'model/Transaction.dart';

void main() {
  //code to fix the orientation to portraitonly
  /*
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  */
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

  bool _showCharts = false;

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
    final isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    //small efficiency here, optional. This will make mediaquery only load once each build. and we can use that connection everywhere in the  method
    final mediaquery = MediaQuery.of(context);
    final appbar = AppBar(
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
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            .7,
        child: TransactionList(_userTransaction, _deleteTransaction));
    return Scaffold(
        appBar: appbar,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Show Chart'),
                    //some widget have the adaptive constructor. it takes same elements inside but difference is
                    // we can get different looks for different platform. for example, this switch will be iOS looking
                    // in iOS phones, and android looking in android phone
                    Switch.adaptive(
                        value: _showCharts,
                        onChanged: (val) {
                          setState(() {
                            _showCharts = val;
                          });
                        }),
                  ],
                ),
              if (!isLandscape)
                Container(
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            mediaquery.padding.top) *
                        .3,
                    child: Chart(_recentTransaction)),
              if (!isLandscape) txListWidget,
              if (isLandscape)
                _showCharts
                    ? Container(
                        height: (mediaquery.size.height -
                                appbar.preferredSize.height -
                                mediaquery.padding.top) *
                            .7,
                        child: Chart(_recentTransaction))
                    : txListWidget
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //this checks for platform, if its in iOS it will not render the button. this check let us do variety of checks
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
                onPressed: () => _startAddNewTransaction(context),
                child: Icon(Icons.add),
              ));
  }
}
