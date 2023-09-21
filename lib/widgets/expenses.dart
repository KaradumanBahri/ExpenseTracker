import 'package:expense_tracker/models/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses.list/expenses_list.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();

}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
  Expense(
      'Flutter Course',
      19.19 ,
      DateTime.now(),
      Category.work,
  ),
    Expense(
      'Cinema',
      15.69 ,
      DateTime.now(),
      Category.liesure ,
    ),
  ];
  void _openAddExpenseOverlay(){
     showModalBottomSheet(
       useSafeArea: true,
       isScrollControlled: true,
       context: context,
         builder: (ctx) =>  NewExpense(onAddExpense: _addExpense),
     );
  }
  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }
  void _romoveExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
          content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo', onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //print(MediaQuery.of(context).size.height);
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some'),
    );
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
          expenses: _registeredExpenses,
          onRomoveExpense: _romoveExpense
      );
    }
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
        body: width < 600 ? Column(
          children:  [
           Chart(expenses: _registeredExpenses),
            Expanded(
                child: mainContent
            ),
          ],
        )
            : Row(
      children: [
         Expanded(
          child:
         Chart(expenses: _registeredExpenses),
      ),
         Expanded(
            child: mainContent
        ),
      ],
     )
    );
  }
}
