import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'login_page.dart';

class VerificationPage extends StatefulWidget {
  final String userEmail;

  const VerificationPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  late Timer _timer;
  int _start = 180; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          // Aquí puedes agregar lógica adicional al finalizar el temporizador
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final String verificationCode = _codeController.text;
    final String userEmail = widget.userEmail;

    final url = Uri.parse('${Constants.baseUrl}/verification/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'verification_code': verificationCode,
        'user_email': userEmail,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final message = responseData['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Constants.colorBlueclaroapp,
            title: Text('Verificación Exitosa'),
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Constants.colorBlueapp),
                SizedBox(width: 8),
                Expanded(child: Text(message)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 400) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final errorMessage = responseData['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Constants.colorRedclaroapp,
            // Color de fondo rojo claro para alerta de error
            title: Text('Error de Verificación'),
            content: Row(
              children: [
                Icon(Icons.error, color: Constants.colorRedapp),
                SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('¿Estás seguro de salir?'),
                content: Text('Si sales, se cancelará la verificación.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Salir'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          // Establece el color de fondo de la AppBar como blanco
          title: Center(
            child: SizedBox(
              height: kToolbarHeight,
              child: Image.asset('assets/logo_banner.png'),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ingresa el Código de verificación',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.colorBlueapp),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 0 ? _codeController.text.substring(0, 1) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 1 ? _codeController.text.substring(1, 2) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 2 ? _codeController.text.substring(2, 3) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 3 ? _codeController.text.substring(3, 4) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 4 ? _codeController.text.substring(4, 5) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.colorBlueapp),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _codeController.text.length > 5 ? _codeController.text.substring(5, 6) : '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                maxLength: 6,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              Text(
                'El Código expira en ${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}.',
                style: TextStyle(fontSize: 16, color: _start > 15 ? Constants.colorBlueapp : Constants.colorRedapp),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: Constants.gradientBlue,
                ),
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // Define el color de fondo del botón como transparente para que el degradado sea visible
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Verificar Correo',
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
}
