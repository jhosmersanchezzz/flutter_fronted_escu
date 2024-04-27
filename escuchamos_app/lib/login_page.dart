import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart'; // Importa Provider
import 'welcome_page.dart'; // Importa WelcomePage si está en otro archivo
import 'register_page.dart'; // Importa RegisterPage si está en otro archivo
import 'auth_provider.dart'; // Importa AuthProvider
import 'constants.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String _errorMessage = '';
  late Timer _timer;
  bool _isLoggingIn = false;
  late String _token; // Variable para almacenar el token
  late int _userId; // Variable para almacenar el ID del usuario

  Color primaryColor = Colors.blue;

  bool _obscureText = true; // Añadido para manejar la visibilidad de la contraseña

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoggingIn) {
      return;
    }
    setState(() {
      _isLoggingIn = true;
    });
    
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor complete todos los campos';
      });
      _timer = Timer(const Duration(seconds: 4), () {
        setState(() {
          _errorMessage = ''; 
        });
      });
      setState(() {
        _isLoggingIn = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/login/'), // Utiliza la variable BASE_URL aquí
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      _token = jsonResponse['token']; // Captura el token
      _userId = jsonResponse['usuario']; // Captura el ID del usuario
      
      // Almacena el token y el ID del usuario en AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setToken(_token);
      authProvider.setUserId(_userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(), 
        ),
      );
    } else if (response.statusCode == 400) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final detail = jsonResponse['detail'];
      setState(() {
        _errorMessage = detail != null ? detail.toString() : 'Usuario o contraseña incorrectos';
        _timer = Timer(const Duration(seconds: 4), () {
          setState(() {
            _errorMessage = ''; 
          });
        });
      });
    }
    setState(() {
      _isLoggingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // Asegúrate de tener la imagen en la carpeta de assets
              height: 130,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Nombre de usuario',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                ),
              ),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText, // Cambiado para manejar la visibilidad de la contraseña
              decoration: InputDecoration(
                hintText: 'Contraseña',
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // Ícono del ojo para visualizar la contraseña
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: Constants.gradientBlue,
              ),
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // Define el color de fondo del botón como transparente para que el degradado sea visible
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Constants.colorRedapp),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                '¿No tienes una cuenta? Regístrate',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Constants.colorBlueapp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
