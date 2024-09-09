
import 'package:expenses_tracker/models/expence.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/drawer.dart';
import 'package:expenses_tracker/widgets/expences_list.dart';
import 'package:expenses_tracker/widgets/new_expences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList('expenses') ?? [];

    final expenseJson = json.encode(expense.toJson());

    expensesJson.add(expenseJson);

    await prefs.setStringList('expenses', expensesJson);

    setState(() {
      _registeredExpenses.add(expense);
    });
  }

void _removeExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList('expenses') ?? [];

    final expenseIndex = _registeredExpenses.indexOf(expense);

    // Remove the expense from the SharedPreferences list
    expensesJson.remove(json.encode(expense.toJson()));
    await prefs.setStringList('expenses', expensesJson);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
            // Also add the undone expense back to the SharedPreferences list
            expensesJson.add(json.encode(expense.toJson()));
            prefs.setStringList('expenses', expensesJson);
          },
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

void _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expensesJson = prefs.getStringList('expenses') ?? [];

    final List<Expense> loadedExpenses = expensesJson
        .map(
          (expenseJson) => Expense.fromJson(
            json.decode(expenseJson),
          ),
        )
        .toList();

    setState(() {
      _registeredExpenses
          .clear(); // Clear existing expenses before adding loaded ones
      _registeredExpenses.addAll(loadedExpenses);
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('ExpenseTracker'),
        toolbarHeight: 90,
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.addchart),
          ),
        ],

      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
