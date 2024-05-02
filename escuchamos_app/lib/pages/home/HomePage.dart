import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:http/http.dart' as http; // Importa http para hacer solicitudes HTTP
import 'package:escuchamos_app/providers/auth_provider.dart'; // Importa AuthProvider
import 'package:escuchamos_app/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Obtiene la instancia de AuthProvider
    final String token = authProvider.token; // Obtiene el token del AuthProvider

    return Scaffold(
      body: FutureBuilder(
        future: fetchUserData(token, authProvider),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} ${authProvider.token} ${authProvider.userId}'));
          } else {
            final username = snapshot.data?['username']; // Obtener el nombre de usuario
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Contenido principal de la página
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20), // Agrega espacio a los lados
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Aquí puedes agregar el contenido principal de la página
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
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserData(String token, AuthProvider authProvider) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/user/${authProvider.userId}'),
      headers: {'Authorization': 'Token $token'}, // Incluye el token en el encabezado
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
