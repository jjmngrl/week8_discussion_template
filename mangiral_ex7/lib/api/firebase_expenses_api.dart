// \api\firebase_expenses_api.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirebaseExpensesApi {
  // Get reference to Firestore collection
  final CollectionReference _expensesCollection = 
    FirebaseFirestore.instance.collection('expenses');

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    try {
      await _expensesCollection.add(expense.toMap());
    } catch (e) {
      print('Error adding expense: $e');
      throw 'Failed to add expense. Please try again.';
    }
  }

  // Get all expenses as a stream
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
        print('Received ${snapshot.docs.length} documents from Firestore'); // Debug
      return snapshot.docs.map((doc) {
        print('Processing document: ${doc.id}'); // Debug
        final data = doc.data() as Map<String, dynamic>;
        try {
          return Expense.fromMap(doc.id, data);
        } catch (e) {
          print('Error parsing document ${doc.id}: $e');
          return Expense(
            id: doc.id,
            name: 'Error loading',
            description: 'Data parsing error',
            category: 'Unknown',
            amount: 0,
          );
        }
      }).toList();
    });
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      await _expensesCollection.doc(expense.id).update(expense.toMap());
    } catch (e) {
      print('Error updating expense: $e');
      throw 'Failed to update expense. Please try again.';
    }
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    try {
      await _expensesCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting expense: $e');
      throw 'Failed to delete expense. Please try again.';
    }
  }

  // Toggle expense paid status
  Future<void> togglePaidStatus(String id, bool isPaid) async {
    try {
      await _expensesCollection.doc(id).update({'isPaid': isPaid});
    } catch (e) {
      print('Error toggling paid status: $e');
      throw 'Failed to update expense status. Please try again.';
    }
  }
}