import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница не найдена'),
      ),
      body: const Center(
        child: Text(
          'Ошибка 404',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 41, 32, 29),
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
