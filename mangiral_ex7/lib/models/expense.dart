// \models\expense.dart
class Expense {
  String? id;
  String name;
  String description;
  String category;
  double amount;
  bool isPaid;

  Expense({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.amount,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'amount': amount,
      'isPaid': isPaid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

factory Expense.fromMap(String id, Map<String, dynamic> map) {
  print('Parsing document with ID: $id and data: $map'); // Debug
  return Expense(
    id: id,
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    category: map['category'] ?? '',
    // Handle different number formats that might come from Firestore
    amount: map['amount'] is int 
      ? (map['amount'] as int).toDouble() 
      : (map['amount'] as double? ?? 0.0),
    isPaid: map['isPaid'] ?? false,
  );
}
}