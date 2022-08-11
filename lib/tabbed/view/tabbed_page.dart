import 'package:flutter/material.dart';
import 'package:pondrop/counter/counter.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/profile/profile.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TabbedPage());
  }

  @override
  _TabbedPageState createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabWidgets = <Widget>[
    CounterPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabWidgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_basket),
              label: l10n.shopping,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: l10n.profile,
            ),
          ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
