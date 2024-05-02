import 'package:escuchamos_app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:escuchamos_app/screens/welcome/welcome_page.dart';
import 'package:escuchamos_app/screens/register/register_page.dart';
import 'package:escuchamos_app/providers/auth_provider.dart';
import 'package:escuchamos_app/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  late Timer _timer;
  bool _isLoggingIn = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
  }

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
      Uri.parse('${Constants.baseUrl}/login/'),
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
      final loginResponse = LoginResponse.fromJson(jsonResponse);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setToken(loginResponse.token);
      authProvider.setUserId(loginResponse.userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomePage(),
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
              'assets/logo.png',
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
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Constants.colorBlueapp) ,
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
                onPressed: _isLoggingIn ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: _isLoggingIn
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
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
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
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
