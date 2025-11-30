import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Create a new transaction
  Future<void> createTransaction({
    required String phone,
    required double amount,
    String? checkoutRequestId,
    String? merchantRequestId,
  }) async {
    try {
      await client.from('transactions').insert({
        'phone': phone,
        'amount': amount,
        'checkout_request_id': checkoutRequestId,
        'merchant_request_id': merchantRequestId,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Update transaction after callback
  Future<void> updateTransaction({
    required String checkoutRequestId,
    required int resultCode,
    required String resultDesc,
    String? mpesaReceipt,
  }) async {
    try {
      await client
          .from('transactions')
          .update({
            'result_code': resultCode,
            'result_desc': resultDesc,
            'mpesa_receipt': mpesaReceipt,
            'status': resultCode == 0 ? 'success' : 'failed',
            'transaction_date': DateTime.now().toIso8601String(),
          })
          .eq('checkout_request_id', checkoutRequestId);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  // Get all transactions
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final List<Map<String, dynamic>> transactions =
          await client.from('transactions').select();
      return transactions;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Stream transactions (realtime)
  Stream<List<Map<String, dynamic>>> streamTransactions() {
    return client.from('transactions').stream(primaryKey: ['id']);
  }
}
