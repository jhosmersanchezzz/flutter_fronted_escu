import 'package:flutter/material.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Cambio de Contraseña',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
