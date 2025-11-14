import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:mac_store_app/views/screens/authentication_screens/register_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/user_provider.dart';

void main() {
  // Run the Flutter App wrapped in a ProviderScope for managing state

  runApp(ProviderScope(child: MyApp()));
}

// Root widget of the application, a consumerWidget to consume the state
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Methode to check the token and set the user data if available
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // Obtain an instance of SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Retrieve token and user JSON string
    String? token = preferences.getString('token');
    String? userJson = preferences.getString('user');



    // Check if both are available
    if (token != null && userJson != null) {
      // Decode user JSON string to a Map
      final userMap = jsonDecode(userJson);

      // Update the user state using provider
      ref.read(userProvider.notifier).setUser(userMap);
    }
    // If token is not available, user is not logged in
    else {
      ref.read(userProvider.notifier).signOut();
    }
  }


  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the token check, show a loading indicator
              return Center(child: CircularProgressIndicator());
            }
            // Check if the user is logged in
            final user = ref.watch(userProvider);
            return user != null
                ? MainScreen() // If user is logged in, show MainScreen
                : LoginScreen(); // If not, show LoginScreen
          },),
    );
  }
}
