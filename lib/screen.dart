import 'package:flutter/material.dart';
import 'package:tv/view/rimocon_page.dart';
import 'package:tv/view/user_page.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int pageIndex = 0;
  List<Widget> pageList = [Remocon(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[pageIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1))),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.apps), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: '')
          ],
          currentIndex: pageIndex,
          onTap: (index) {
            print('tap');
            pageIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }
}
