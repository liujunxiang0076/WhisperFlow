import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhisperFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TranslatorHomePage(),
    );
  }
}

class TranslatorHomePage extends StatefulWidget {
  const TranslatorHomePage({super.key});

  @override
  State<TranslatorHomePage> createState() => _TranslatorHomePageState();
}

class _TranslatorHomePageState extends State<TranslatorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.black87, // Dark background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          elevation: 8.0,
          child: Container(
            width: double.infinity,
            height: 500, // "Huge" card
            padding: const EdgeInsets.all(32.0),
            alignment: Alignment.center,
            child: const Text(
              '点击下方按钮开始实时抓取翻译',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // TODO: Implement recording logic
        },
        tooltip: '开始',
        child: const Icon(Icons.mic),
      ),
    );
  }
}
