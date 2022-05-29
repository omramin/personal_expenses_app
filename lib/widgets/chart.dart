import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';
import '../models/transcation.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  // a getters need a body! here we'll return the List<>
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // weekday: to group the transactions that happened on a specefic day
      // deducting days from DateTime.now() to get the total 7 days (week ago)
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        // the checking only succeed if it has the same day, month & year
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        //DateFormat.E() gives us a shortcut for the weekday
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
      // we use reversed to get a reversed list, reordering our list, our weekdays
    }).reversed.toList();
  }

  // to calculate the total spending if the week, summing up all the amounts,
  // calculating the total sum of the entire week
  double get totalSpending {
    // fold expects an initial value & return a new value wich will be added to this starting value
    // returning a new value for every run on every item in in the groupedTransactionValues list
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            // if add larg amount don't change their size, shrinking the lable
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                // checking if ZERO pass 0.0 otherwise pass the PCT of the total
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
