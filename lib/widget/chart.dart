import 'package:ExpenseTracker/model/Transaction.dart';
import 'package:ExpenseTracker/widget/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        //checking if day , month and year matches.
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year) {
          totalSum += recentTransaction[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekday), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    //fold() method calculated sum of a single element from a collection of value. here we pass the initial sum to zero,
    // then add them together one by one through eterating
    return groupedTransactionValues.fold(
        0.0, (previousValue, element) => previousValue + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //a list of groupedtransactionvalues which we traverse and make a test to see if we can print day and amount
          children: groupedTransactionValues
              .map((e) => Flexible(
                    //flexible is used so that the amount doesnt take extra space when value gets too high
                    fit: FlexFit.tight,
                    child: ChartBar(
                        e['day'],
                        e['amount'],
                        totalSpending == 0.0
                            ? 0.0
                            : (e['amount'] as double) / totalSpending),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
