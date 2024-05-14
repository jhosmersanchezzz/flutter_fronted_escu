import 'package:flutter/material.dart';
import 'package:escuchamos_app/constants/constants.dart';
import 'package:escuchamos_app/pages/medication/MedicationPage.dart';
import 'package:escuchamos_app/pages/profile/ProfilePage.dart';
import 'package:escuchamos_app/pages/explore/ExplorePage.dart';
import 'package:escuchamos_app/pages/home/HomePage.dart';
import 'package:escuchamos_app/pages/notifications/NotificationsPage.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;
  bool _isVisible = true;
  bool _isAppBarVisible = true;
  double _lastScrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isAppBarVisible ? 1.0 : 0.0,
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.person,
                color: Constants.colorBlueapp,
                size: 34,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
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
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
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
          gradient: Constants.gradientBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconButton(Icons.home, 0),
            _buildIconButton(Icons.search, 1),
            _buildIconButton(Icons.notifications, 2),
            _buildIconButton(Icons.local_pharmacy, 3),
          ],
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
