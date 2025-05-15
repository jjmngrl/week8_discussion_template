import '../api/firebase_expenses_api.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseExpensesApi _api = FirebaseExpensesApi();

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _api.addExpense(expense);
  }

  // Get all expenses
  Stream<List<Expense>> getExpenses() {
    return _api.getExpenses();
  }

  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    await _api.updateExpense(expense);
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    await _api.deleteExpense(id);
  }
  
  // Toggle expense paid status
  Future<void> togglePaidStatus(String id, bool isPaid) async {
    await _api.togglePaidStatus(id, isPaid);
  }
}