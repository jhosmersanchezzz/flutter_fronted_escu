import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'login_page.dart'; // Importa RegisterPage si está en otro archivo


class Country {
  final int id;
  final String abbreviation;
  final String dialingCode;

  Country({
    required this.id,
    required this.abbreviation,
    required this.dialingCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      abbreviation: json['name'],
      dialingCode: json['dialing_code'],
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  bool _obscureText = true;
  bool _obscureConfirmText = true;

  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _emailError;
  String? _nameError;
  String? _lastNameError;
  String? _addressError;
  String? _phoneNumberError;
  String? _countryError;

  Timer? _errorMessageTimer; // Timer para controlar la duración del mensaje de error

  List<Country> _countries = [];
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final url = Uri.parse('${Constants.baseUrl}/countries');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['countries']; // Corrección aquí
      setState(() {
        _countries = data.map((item) => Country.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to fetch countries');
    }
  }

  @override
  void dispose() {
    _errorMessageTimer?.cancel(); // Cancela el temporizador cuando se dispose el widget
    super.dispose();
  }

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      _usernameError = _validateField(usernameController.text);
      _passwordError = _validateField(passwordController.text);
      _confirmPasswordError = _validateField(confirmPasswordController.text);
      _emailError = _validateField(emailController.text);
      _nameError = _validateField(nameController.text);
      _lastNameError = _validateField(lastNameController.text);
      _addressError = _validateField(addressController.text);
      _phoneNumberError = _validateField(phoneNumberController.text);
      _countryError = _selectedCountry == null ? 'Este campo es obligatorio' : null;
    });

    if (_usernameError != null ||
        _passwordError != null ||
        _confirmPasswordError != null ||
        _emailError != null ||
        _nameError != null ||
        _lastNameError != null ||
        _addressError != null ||
        _phoneNumberError != null ||
        _countryError != null) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Las contraseñas no coinciden.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.parse('${Constants.baseUrl}/register/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'name': nameController.text,
        'last_name': lastNameController.text,
        'address': addressController.text,
        'phone_number': phoneNumberController.text,
        'country_id': _selectedCountry?.id, // Agregar el id del país seleccionado
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginPage(), // Navega a la página de inicio de sesión
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(-1.0, 0.0); // Cambio: Se cambia el inicio de la transición a la izquierda (-1.0)
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
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final errorMessage = responseData.values.join('\n');
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  String? _validateField(String value) {
    if (value.isEmpty) {
      // Si el valor está vacío, muestra el mensaje de error y comienza el temporizador
      _startErrorMessageTimer();
      return 'Este campo es obligatorio';
    }
    // Si el valor no está vacío, cancela el temporizador
    _cancelErrorMessageTimer();
    return null;
  }

  // Método para iniciar el temporizador para el mensaje de error
  void _startErrorMessageTimer() {
    _errorMessageTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        // Limpia los mensajes de error después de 3 segundos
        _usernameError = null;
        _passwordError = null;
        _confirmPasswordError = null;
        _emailError = null;
        _nameError = null;
        _lastNameError = null;
        _addressError = null;
        _phoneNumberError = null;
        _countryError = null;
      });
    });
  }

  // Método para cancelar el temporizador para el mensaje de error
  void _cancelErrorMessageTimer() {
    _errorMessageTimer?.cancel();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Colors.white, // Establecer el color de fondo en blanco
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _usernameError,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                errorText: _passwordError,
              ),
              obscureText: _obscureText,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _confirmPasswordError,
              ),
              obscureText: _obscureConfirmText,
              onChanged: (value) {
                setState(() {
                  _obscureConfirmText = !_obscureConfirmText;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Country>(
              value: _selectedCountry,
              onChanged: (Country? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                  // Actualiza el campo de número de teléfono al seleccionar un país
                  phoneNumberController.text = _selectedCountry?.dialingCode ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'País',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _countryError,
              ),
              items: _countries.map<DropdownMenuItem<Country>>((Country country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Text(
                    '${country.abbreviation} (${country.dialingCode})',
                    style: const TextStyle(fontSize: 11.0), // Tamaño de letra más pequeño
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _emailError,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombres',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _lastNameError,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _addressError,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Número de teléfono',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.colorBlueapp), // Cambio: Agregado el color azul al borde enfocado
                ),
                errorText: _phoneNumberError,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                gradient: Constants.gradientBlue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _registerUser(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent), // Hace que el botón sea transparente
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Center(
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextButton( // Cambio: Se agrega el TextButton al final del formulario
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(), // Cambio: Se cambia la clase a la que redirige
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(-1.0, 0.0); // Cambio: Se cambia el inicio de la transición a la izquierda (-1.0)
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
                '¿Ya tienes una cuenta? Inicia sesión',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Constants.colorBlueapp,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
