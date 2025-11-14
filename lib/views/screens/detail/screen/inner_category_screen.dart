import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/inner_category_content_widget.dart';
import 'package:mac_store_app/views/screens/detail/screen/widgets/inner_header_widget.dart';
import '../../../../models/category.dart';
import '../../nav_screens/account_screen.dart';
import '../../nav_screens/cart_screen.dart';
import '../../nav_screens/category_screen.dart';
import '../../nav_screens/favorite_screen.dart';
import '../../nav_screens/stores_screen.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;

  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int pageIndex = 0;


  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
      InnerCategoryContentWidget(category: widget.category),
      FavoriteScreen(),
      CategoryScreen(),
      StoresScreen(),
      CartScreen(),
      AccountScreen(),
    ];


    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                width: 25,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/love.png", width: 25),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/love.png", width: 25),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Stores"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/cart.png", width: 25),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/user.png", width: 25),
              label: "Account"),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
