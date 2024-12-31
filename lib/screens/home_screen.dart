import 'package:flutter/material.dart';
import '../widgets/navigation_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationHandler(
      selectedIndex: selectedIndex,
      onIndexChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
