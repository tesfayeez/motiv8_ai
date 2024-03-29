import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/constants.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class HomeViewScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const HomeViewScreen());
  const HomeViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewScreenState createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends ConsumerState<HomeViewScreen> {
  int _page = 0;

  final List<String> tabAssets = [
    'assets/Home.svg',
    'assets/mygoals.svg',
    'assets/Setting.svg',
    'assets/Profile.svg',
  ];

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void loadSvg(String assetName) {
    final loader = SvgAssetLoader(assetName);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }

  @override
  void initState() {
    super.initState();

    // Load all SVG assets
    tabAssets.forEach(loadSvg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: theme.colorScheme.onBackground,
        currentIndex: _page,
        onTap: onPageChange,
        border: const Border(
          top: BorderSide(color: Colors.transparent),
        ),
        items: tabAssets.map((asset) {
          final index = tabAssets.indexOf(asset);
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              asset,
              colorFilter: ColorFilter.mode(
                _page == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onTertiary,
                BlendMode.srcIn,
              ),
            ),
            label: _getPageText(index),
          );
        }).toList(),
      ),
    );
  }

  String _getPageText(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'My Goals';
      case 2:
        return 'Settings';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }
}
