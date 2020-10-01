import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //another way of getting user input is below
  final Function _addNewTransaction;

  NewTransaction(this._addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectDate;

  void submitData() {
    //this check is to avoid error if no value is added
    if (amountController.text.isEmpty || titleController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectDate == null) {
      return;
    }
    //widget property helps us to access the property of our widget class inside our state class.
    //both are technically are in different class.
    widget._addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectDate,
    );
    //closing the transaction widget after the add button is pressed, this method is closing the topmost widget that is opened
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    //showdatepicker returns a Future class object, this class can hold objects which are recieved in future.
    //then() method can handle what to do after its value recieved
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //wrapped with single child scrollview, cause the modalbtoomsheet have its fixed height.
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              //viewinsets gives the parts of the UI that is taken by the system UI, typically like keyboard etc
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => submitData(),
                //underscore here means, we accepting a parameter in this function, but we dont care about it.
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              //datepicker elements inside this row
              Row(
                children: <Widget>[
                  Text(_selectDate == null
                      ? 'No Date Choosen'
                      : DateFormat.yMd().format(_selectDate)),
                  FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              RaisedButton(
                onPressed: submitData,
                color: Theme.of(context).primaryColor,
                child: Text('Add Transaction'),
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
