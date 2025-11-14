import 'dart:convert'; // Make sure this is imported
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/global_variable.dart';
import 'package:mac_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';

final providerContainer = ProviderContainer();

class UserController {
  // method to sign up users
  Future<void> signUpUsers({
    required context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: jsonEncode(user.toJson()), // 👈 FIXED: Encode to JSON string
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
          showSnackBar(context, 'Account created successfully');
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Account creation failed');
    }
  }

  // method to sign in users
  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode(
            {"email": email, "password": password}), // 👈 Create a map here
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // Access sharedPreferences for token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // Store the token in shared preferences
          String token = jsonDecode(response.body)['token'];
          // Store the user data in shared preferences
          await preferences.setString('token', token);
          // Encode the user data to JSON
          final userMap = jsonDecode(response.body)['user'];
          final userJson = jsonEncode(userMap); // Whole user object is in root
          // print('userMap: $userMap');

          // update the application state with the user data using Riverpod
          providerContainer.read(userProvider.notifier).setUser(userMap);
          // store the user data in shared preferences for the future
          await preferences.setString('user', userJson);
          // print('userJson: $userJson');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (route) => false,
          );
          showSnackBar(context, 'Login successfully');
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Login failed');
    }
  }

  // method to sign out users
  Future<void> signOutUsers({
    required context,
  }) async {
    try {
      // Access sharedPreferences for token and user data storage
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // Clear the token and user data from shared preferences
      await preferences.remove('token');
      await preferences.remove('user');
      // Reset the user state in the application using Riverpod
      providerContainer.read(userProvider.notifier).signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
      showSnackBar(context, 'Logout successfully');
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Logout failed');
    }
  }

  // method Update user's state, city and locality
  Future<void> updateUserLocation({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
}) async {

    try {

      http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        body: jsonEncode(
            {"state": state, "city": city , "locality" : locality}), // 👈 Create a map here
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // Access sharedPreferences for token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // Encode the user data to JSON
          final updateUser = jsonDecode(response.body);
          final userJson = jsonEncode(updateUser); // Whole user object is in root
          // print('userMap: $userMap');

          // update the application state with the user data using Riverpod
          providerContainer.read(userProvider.notifier).setUser(updateUser);
          // store the user data in shared preferences for the future
          await preferences.setString('user', userJson);

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MainScreen(),
          //   ),
          //       (route) => false,
          // );
          showSnackBar(context, 'Update location successfully');
        },
      );

    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'Error updating location');
    }

  }
}
