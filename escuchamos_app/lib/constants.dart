import 'package:flutter/material.dart';

class Constants {

  // ---------------------------URL base de la API ---------------------------//

  //url para pruebas locales:
  //static const String baseUrl = 'http://127.0.0.1:8000'; 

    //url para pruebas en el servidor:
  static const String baseUrl = 'https://escuchamos.onrender.com'; 

  // -------------------------------------------------------------------------//




  // ---------------------------colores de la app ---------------------------//

  static const Color colorBlueapp = Color.fromRGBO(22, 45, 222, 1); // Color azul que esta casi en todo la app
  static const Color colorBlueclaroapp = Color.fromRGBO(226, 227, 248, 1); // Color azul claro en las notificaciones de la app
  static const Color colorPurpleapp = Color.fromRGBO(74, 1, 125, 1); // Color morado
  static const Color colorRedapp = Color.fromRGBO(234, 22, 19, 1); // Color rojo
  static const Color colorRedclaroapp = Color.fromRGBO(255, 225, 224, 1); // Color rojo claro en las notificaciones de error de la app 

  // -------------------------------------------------------------------------//



  // ---------------------------degradados de la app ---------------------------//

  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topCenter, // Establece el punto de inicio en la parte superior
    end: Alignment.bottomCenter, // Establece el punto final en la parte inferior
    colors: [
      Color.fromRGBO(22, 45, 222, 1),// primer color
      Color.fromRGBO(74, 1, 125, 1), // Segundo color
    ],
  );

    // -------------------------------------------------------------------------//



  
}
