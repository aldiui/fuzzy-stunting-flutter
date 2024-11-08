import 'package:flutter/material.dart';
import 'package:stunting_android/screens/article_page.dart';
import 'package:stunting_android/screens/analyzer_page.dart';
import 'package:stunting_android/screens/consultation_page.dart';
import 'package:stunting_android/screens/profile_page.dart';
import 'package:stunting_android/screens/welcome_page.dart';

class MyHomePage extends StatefulWidget {
  final int selectedIndex;

  const MyHomePage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const WelcomePage(),
    const ArticlePage(),
    const AnalyzerPage(),
    const ConsultationPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Analyzer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
