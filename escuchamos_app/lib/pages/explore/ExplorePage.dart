import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        // Elimina el AppBar
        body: Center(
          child: Text(
            '¡Hola, mundo! Exploreeee',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}
