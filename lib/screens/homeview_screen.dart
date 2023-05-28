import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiv8_ai/commons/constants.dart';

class HomeViewScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const HomeViewScreen());
  const HomeViewScreen({
    super.key,
  });

  @override
  _HomeViewScreenState createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        border: const Border(
            top: BorderSide(color: Colors.transparent)), // Add this line
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _page == 0 ? Icons.home_filled : Icons.home_outlined,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 2 ? Icons.analytics : Icons.analytics_outlined,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 3 ? Icons.settings : Icons.settings_applications_sharp,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
