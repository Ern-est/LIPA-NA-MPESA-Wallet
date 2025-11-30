import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/payment/presentation/screens/home_screen.dart';
import 'features/payment/presentation/screens/payment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MpesaCloneApp()));
}

class MpesaCloneApp extends StatelessWidget {
  const MpesaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lipa na Mpesa Clone",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),

      // Initial screen
      home: const HomeScreen(),

      // Register routes
      routes: {"/pay": (_) => const PaymentScreen()},
    );
  }
}
