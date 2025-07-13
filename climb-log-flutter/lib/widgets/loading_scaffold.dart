import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  final String titleText;
  const LoadingScaffold({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: const Center(child: CircularProgressIndicator())
    );
  }
}
