import 'package:flutter/material.dart';

class Constants {

  // ---------------------------URL base de la API ---------------------------//

  //static const String baseUrl = 'http://127.0.0.1:8000'; 
  static const String baseUrl = 'https://escuchamos.onrender.com'; 

  // -------------------------------------------------------------------------//




  // ---------------------------colores de la app ---------------------------//

  static const Color colorBlueapp = Color.fromRGBO(22, 45, 222, 1); // Color azul que esta casi en todo la app
  static const Color colorPurpleapp = Color.fromRGBO(74, 1, 125, 1); // Color morado
  static const Color colorRedapp = Color.fromRGBO(234, 22, 19, 1); // Color rojo

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
