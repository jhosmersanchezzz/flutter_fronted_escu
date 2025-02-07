import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:escuchamos_app/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdateDataView extends StatefulWidget {
  const UpdateDataView({Key? key});

  @override
  _UpdateDataViewState createState() => _UpdateDataViewState();
}

class _UpdateDataViewState extends State<UpdateDataView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;


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
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      try {
        final userId = await storage.read(key: 'userId');
        final response = await http.get(
          Uri.parse('${Constants.baseUrl}/user/$userId'),
          headers: {'Authorization': 'Token $token'},
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
    } else {
      // Token not available, handle accordingly
      print('Token not available');
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

      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final userId = await storage.read(key: 'userId');

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/user/update/$userId'),
        headers: {
          'Authorization': 'Token $token',
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
          backgroundColor: Constants.colorRedclaroapp,
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
    backgroundColor: Colors.white,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remueve la sombra del appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Constants.colorBlueapp),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Image.asset('assets/logo_banner.png', height: kToolbarHeight), // Ajusta la altura del logo al del appbar
        ),
        centerTitle: true,
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
              decoration: InputDecoration(
                hintText: 'Nombre de usuario',
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                  borderRadius: BorderRadius.circular(8.0),
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
              decoration: InputDecoration(
                hintText: 'Correo electrónico',
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                  borderRadius: BorderRadius.circular(8.0),
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
              decoration: InputDecoration(
                hintText: 'Dirección',
                labelText: 'Dirección',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                  borderRadius: BorderRadius.circular(8.0),
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
              decoration: InputDecoration(
                hintText: 'Número telefónico',
                labelText: 'Número telefónico',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                  borderRadius: BorderRadius.circular(8.0),
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
