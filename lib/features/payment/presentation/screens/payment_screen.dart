import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/supabase_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  final supabaseService = SupabaseService();

  bool isLoading = false;
  String statusMessage = '';
  Color statusColor = Colors.black;

  @override
  void initState() {
    super.initState();

    // Realtime listener
    supabaseService.streamTransactions().listen((event) {
      final transactions =
          event.map((e) => e['new'] as Map<String, dynamic>).toList();

      for (var tx in transactions) {
        if (tx['phone'] == phoneController.text.trim()) {
          setState(() {
            if (tx['status'] == 'success') {
              statusMessage =
                  "Payment Successful! Receipt: ${tx['mpesa_receipt']}";
              statusColor = Colors.green;
              isLoading = false;
            } else if (tx['status'] == 'failed') {
              statusMessage = "Payment Failed: ${tx['result_desc']}";
              statusColor = Colors.red;
              isLoading = false;
            }
          });
        }
      }
    });
  }

  Future<void> payNow() async {
    final phone = phoneController.text.trim();
    final amountText = amountController.text.trim();
    if (phone.isEmpty || amountText.isEmpty) {
      setState(() {
        statusMessage = "Enter valid phone and amount";
        statusColor = Colors.red;
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      setState(() {
        statusMessage = "Enter a valid numeric amount";
        statusColor = Colors.red;
      });
      return;
    }

    setState(() {
      isLoading = true;
      statusMessage = "Initiating Payment...";
      statusColor = Colors.blue;
    });

    try {
      final response = await http.post(
        Uri.parse(
          "https://kqnlysiojxbvwyxqbrpo.supabase.co/functions/v1/super-function",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['SUPABASE_ANON_KEY']}',
        },
        body: jsonEncode({"phone": phone, "amount": amount}),
      );

      final data = jsonDecode(response.body);

      if (data['error'] != null) {
        setState(() {
          statusMessage = "Error: ${data['error']}";
          statusColor = Colors.red;
          isLoading = false;
        });
        return;
      }

      setState(() {
        statusMessage = "STK Push sent! Check your phone...";
        statusColor = Colors.blue;
      });
    } catch (e) {
      setState(() {
        statusMessage = "Payment error: $e";
        statusColor = Colors.red;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("LIPA NA MPESA Clone"),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number (2547XXXXXXXX)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.money),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : payNow,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green[700],
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Pay Now",
                              style: TextStyle(fontSize: 18),
                            ),
                  ),
                  const SizedBox(height: 24),
                  if (statusMessage.isNotEmpty)
                    Text(
                      statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
