import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:escuchamos_app/auth_provider.dart';
import 'package:escuchamos_app/pages/profile_views/update_data_view.dart';
import 'package:escuchamos_app/pages/profile_views/change_password_view.dart';
import 'package:escuchamos_app/login_page.dart';
import 'package:escuchamos_app/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user/${authProvider.userId}'),
        headers: {'Authorization': 'Token ${authProvider.token}'},
      );
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(responseBody);
        setState(() {
          userData = data;
        });
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _logout() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/logout/'),
        headers: {'Authorization': 'Token ${authProvider.token}'},
      );
      if (response.statusCode == 200) {
        // Eliminar todas las rutas anteriores y reemplazar con la página de inicio de sesión
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  _buildUserInfo(
                    username: userData['username'] ?? '',
                    email: userData['email'] ?? '',
                    name: userData['name'] ?? '',
                    lastName: userData['last_name'] ?? '',
                    address: userData['address'] ?? '',
                    phoneNumber: userData['phone_number'] ?? '',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          Icons.update,
                          color: Constants.colorBlueapp,
                        ),
                        title: const Text(
                          'Actualizar Datos',
                          style: TextStyle(
                            color: Constants.colorBlueapp,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDataView(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Constants.colorBlueapp,
                        ),
                        title: const Text(
                          'Cambiar Contraseña',
                          style: TextStyle(
                            color: Constants.colorBlueapp,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordView(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Constants.colorBlueapp,
                        ),
                        title: const Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Constants.colorBlueapp,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                  color: Constants.colorBlueapp,
                                ),
                              ),
                              content: const Text(
                                '¿Estás seguro de que quieres cerrar sesión?',
                                style: TextStyle(
                                  color: Constants.colorBlueapp,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Constants.colorBlueapp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _logout();
                                  },
                                  child: const Text(
                                    'Cerrar sesión',
                                    style: TextStyle(
                                      color: Constants.colorBlueapp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                    color: Constants.colorBlueapp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo({
    required String username,
    required String email,
    required String name,
    required String lastName,
    required String address,
    required String phoneNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Nombre de usuario', username),
          _buildInfoItem('Correo electrónico', email),
          _buildInfoItem('Nombre completo', '$name $lastName'),
          _buildInfoItem('Dirección', address),
          _buildInfoItem('Número telefónico', phoneNumber),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Constants.colorBlueapp,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
