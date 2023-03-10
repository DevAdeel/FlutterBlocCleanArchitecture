import 'package:bloc_clean_architecture/features/number_trivia/presentations/pages/number_trivia_page.dart';
import 'package:bloc_clean_architecture/injection_container.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        brightness: Brightness.light,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
