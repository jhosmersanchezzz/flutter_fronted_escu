import 'package:flutter/material.dart';
import 'package:escuchamos_app/screens/welcome/welcome_page.dart';
import 'package:escuchamos_app/screens/login/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:escuchamos_app/providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(), // Aquí debes crear tu AuthProvider
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'EscuChamos',
            routes: {
              '/login': (context) => LoginPage(),
              // Otras rutas aquí...
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: snapshot.data == true ? const WelcomePage() : const LoginPage(),
            debugShowCheckedModeBanner: false, // Esta línea oculta el banner de depuración
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  static Future<bool> _checkLoggedIn() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
