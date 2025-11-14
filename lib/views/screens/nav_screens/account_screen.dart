import 'package:flutter/material.dart';
import 'package:mac_store_app/controllers/user_controller.dart';
import 'package:mac_store_app/views/screens/detail/screen/order_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async {
              // Call the signOut method from UserController
              await userController.signOutUsers(context: context);


            }, child: Text('Logout')),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(),));
            }, child: Text('My Order'))
          ],
        ),
      ),
    );
  }
}
