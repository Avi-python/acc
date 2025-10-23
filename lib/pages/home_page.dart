import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'add_transaction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.transactions.isEmpty) {
            return const Center(
              child: Text('No transactions yet.\nTap + to add one!'),
            );
          }

          return Column(
            children: [
              _buildSummaryCard(provider),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = provider.transactions[index];
                    return _buildTransactionTile(
                        context, transaction, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTransactionPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(TransactionProvider provider) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Income', provider.totalIncome, Colors.green),
            _buildSummaryItem('Expense', provider.totalExpenses, Colors.red),
            _buildSummaryItem('Balance', provider.balance, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    Transaction transaction,
    TransactionProvider provider,
  ) {
    final isIncome = transaction.type == TransactionType.income;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green : Colors.red,
        child: Icon(
          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          color: Colors.white,
        ),
      ),
      title: Text(transaction.name),
      subtitle: Text(
        '${transaction.category} • ${_formatDate(transaction.date)}',
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onLongPress: () => _showDeleteDialog(context, transaction, provider),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(
    BuildContext context,
    Transaction transaction,
    TransactionProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Delete "${transaction.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTransaction(transaction.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
