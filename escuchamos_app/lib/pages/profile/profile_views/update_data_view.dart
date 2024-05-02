import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:escuchamos_app/providers/auth_provider.dart';
import 'package:escuchamos_app/constants/constants.dart';

class UpdateDataView extends StatefulWidget {
  const UpdateDataView({super.key});

  @override
  _UpdateDataViewState createState() => _UpdateDataViewState();
}

class _UpdateDataViewState extends State<UpdateDataView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;

  final bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
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
      final Map<String, dynamic> userData = json.decode(responseBody);
      _usernameController.text = userData['username'];
      _emailController.text = userData['email'];
      _addressController.text = userData['address'];
      _phoneNumberController.text = userData['phone_number'];
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
}

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> userData = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "phone_number": _phoneNumberController.text,
      };

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/user/update/${authProvider.userId}'),
        headers: {
          'Authorization': 'Token ${authProvider.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );

            if (response.statusCode == 200) {
              _showSuccessDialog();
            } else {
              _showErrorDialog();
            }
          } else {
            _showIncompleteFieldsDialog();
          }
        }

        void _showSuccessDialog() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Constants.colorBlueclaroapp,
                title: const Text('¡Datos actualizados correctamente!'),
                content: const Icon(Icons.check_circle, color: Constants.colorBlueapp, size: 50),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }

        void _showErrorDialog() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Constants.colorRedclaroapp, // Color de fondo rojo claro para alerta de error
                title: const Text('Error al actualizar los datos'),
                content: const Icon(Icons.error, color: Constants.colorRedapp, size: 50),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }

        void _showIncompleteFieldsDialog() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Por favor completa todos los campos obligatorios'),
                content: const Icon(Icons.warning, color: Colors.orange, size: 50),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isAppBarVisible ? 1.0 : 0.0,
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Constants.colorBlueapp),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Center(
              child: SizedBox(
                height: kToolbarHeight,
                child: Image.asset('assets/logo_banner.png'),
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Nombre de usuario',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Nombre de usuario',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.colorBlueapp),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Correo electrónico',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.colorBlueapp),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo electrónico';
                  }
                  // Puedes agregar validaciones adicionales de correo electrónico aquí
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                hintText: 'Dirección',
                hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.colorBlueapp),
                  ),
                ),
                validator: (value) {
                  // Puedes agregar validaciones adicionales de dirección aquí
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                hintText: 'Número telefónico',
                hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Número telefónico',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.colorBlueapp),
                  ),
                ),
                validator: (value) {
                  // Puedes agregar validaciones adicionales de número telefónico aquí
                  return null;
                },
              ),
              const SizedBox(height: 20),

Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: Constants.gradientBlue,
              ),
              child: ElevatedButton(
                onPressed: _updateUserData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // Define el color de fondo del botón como transparente para que el degradado sea visible
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  'Actualizar Datos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),



            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
