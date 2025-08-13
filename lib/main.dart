import 'package:flutter/material.dart';
import 'package:chess_game/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chess_game/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures Flutter binding is ready
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess Game Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
