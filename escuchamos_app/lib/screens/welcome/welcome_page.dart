import 'package:flutter/material.dart';
import 'package:escuchamos_app/constants/constants.dart';
import 'package:escuchamos_app/pages/medication/MedicationPage.dart';
import 'package:escuchamos_app/pages/profile/ProfilePage.dart';
import 'package:escuchamos_app/pages/explore/ExplorePage.dart';
import 'package:escuchamos_app/pages/home/HomePage.dart';
import 'package:escuchamos_app/pages/notifications/NotificationsPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;
  bool _isVisible = true;
  bool _isAppBarVisible = true;
  double _lastScrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Muestra la ventana emergente de confirmación al presionar el botón de retroceso
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Estás seguro de salir?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ?? false; // Si el usuario toca fuera del dialogo, no se sale de la app
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isAppBarVisible ? 1.0 : 0.0,
            child: AppBar(
              backgroundColor: Colors.white, // Establece el color de fondo de la AppBar como blanco
              leading: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Constants.colorBlueapp, // Utiliza el último color del degradado
                  size: 34, // Tamaño del icono del app bar
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 4; // Cambiar a la página de perfil
                  });
                },
              ),
              title: Center(
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Image.asset('assets/logo_banner.png'),
                ),
              ),
              actions: const [],
              centerTitle: true,
              automaticallyImplyLeading: false, // Eliminar la flecha de retroceso
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent, // Espacio ocupado por el AppBar
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (_selectedIndex == 1 && scrollNotification is ScrollUpdateNotification) {
                  final newScrollPosition = scrollNotification.metrics.pixels;
                  if (newScrollPosition > _lastScrollPosition && _isVisible) {
                    setState(() {
                      _isVisible = false;
                      _isAppBarVisible = false;
                    });
                  } else if (newScrollPosition < _lastScrollPosition && !_isVisible) {
                    setState(() {
                      _isVisible = true;
                      _isAppBarVisible = true;
                    });
                  }
                  _lastScrollPosition = newScrollPosition;
                }
                return true;
              },
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  HomePage(),
                  ExplorePage(),
                  NotificationsPage(),
                  MedicationPage(),
                  ProfilePage(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isVisible ? 50 : 0,
          decoration: const BoxDecoration(
            gradient: Constants.gradientBlue, // Utiliza el degradado definido en Constants
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.home, 0),
              _buildIconButton(Icons.search, 1), // Icono de búsqueda
              _buildIconButton(Icons.notifications, 2),
              _buildIconButton(Icons.local_pharmacy, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Icon(
          iconData,
          key: ValueKey<int>(_selectedIndex),
          size: _selectedIndex == index ? 34 : 24,
          color: _selectedIndex == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
