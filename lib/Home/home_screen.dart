import 'package:clothes_shop/Home/widgets/custom_drawer.dart';
import 'package:clothes_shop/cart/cart_screen.dart';
import 'package:clothes_shop/controller/cart_controller.dart';
import 'package:clothes_shop/controller/product_controller.dart';
import 'package:clothes_shop/favorite/favorite_screen.dart';
import 'package:clothes_shop/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import 'widgets/home_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // ✅ Register CartController ONCE for the entire app
  @override
  void initState() {
    super.initState();
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
  }

  late final List<Widget> _pages = [
    _homePage(),
    FavoriteScreen(),
    CartScreen(),
    const UserScreen(),
  ];

  // 👇 Function to open drawer
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // 👇 Home Page Layout
  Widget _homePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeAppBar(openDrawer: _openDrawer),
          const HomeBody(),
        ],
      ),
    );
  }

  // 👇 Bottom navigation tab handler
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),

      // Show selected page
      body: SafeArea(child: _pages[_selectedIndex]),

      // Bottom Navigation Bar
      bottomNavigationBar: HomeBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
