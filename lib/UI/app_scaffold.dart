import 'package:flutter/material.dart';
import 'home_screen.dart';


class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int index = 0;

  final pages = const [
    HomeScreen(),
    Center(child: Text('Offers')),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.grey,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          selectedItemColor: Color(0xFF2F6BFF),
          selectedLabelStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}