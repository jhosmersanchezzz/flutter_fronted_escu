import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escuchamos_app/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final username = snapshot.data?['username'];
            final token = snapshot.data?['token'];
            if (token == null || token.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No hay sesión iniciada. Por favor, inicia sesión.'),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¡Bienvenido a la aplicación!',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$username, este es tu hogar. Puedes agregar cualquier contenido aquí.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tu token es: $token',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'userId');

    if (token == null || userId == null) {
      throw Exception('Token or userId not available');
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/user/$userId'),
      headers: {'Authorization': 'Token $token'}, // Incluye el token en el encabezado
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      userData['token'] = token;
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
