import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'add_expense_screen.dart';
import 'expense_detail_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),
        builder: (context, snapshot) {
          // Add debug print to see what's happening
          print('Stream data: ${snapshot.data}');
          print('Stream error: ${snapshot.error}');
          print('Stream connection state: ${snapshot.connectionState}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found'));
          }
          
          final expenses = snapshot.data!;
          
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Dismissible(
                key: Key(expense.id!),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Expense'),
                      content: const Text('Are you sure you want to delete this expense?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  _expenseService.deleteExpense(expense.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${expense.name} deleted')),
                  );
                },
                child: ListTile(
                  title: Text(expense.name),
                  subtitle: Text(expense.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${expense.amount.toStringAsFixed(2)}'),
                      const SizedBox(width: 8),
                      Icon(
                        expense.isPaid ? Icons.check_circle : Icons.pending_outlined,
                        color: expense.isPaid ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseDetailScreen(expense: expense),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}