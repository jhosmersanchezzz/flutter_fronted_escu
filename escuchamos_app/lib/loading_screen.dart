import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Importa SpinKit
import 'login_page.dart';
import 'constants.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Se inicia un temporizador de 4 segundos
    Timer(const Duration(seconds: 4), () {
      // Cuando el temporizador finaliza, se navega a la página de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí colocamos tu logo
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Indicador de carga SpinKitWave
            const SpinKitWave(
              color: Constants.colorBlueapp, // Color del indicador
              size: 45.0, // Tamaño del indicador
            ),
          ],
        ),
      ),
    );
  }
}
