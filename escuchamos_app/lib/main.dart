import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart'; // Importa AuthProvider si está en otro archivo
import 'screens/login/login_page.dart'; // Importa la pantalla de carga

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false, // Oculta el banner de depuración
        // Utiliza la pantalla de carga antes de abrir LoginPage()
        home: LoginPage(), // Aquí se muestra la pantalla de carga 
      ),
    );
  }
}