import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // the HTTP response from the request
  required BuildContext context,
  // the context is to show snackbar
  required VoidCallback onSuccess,
}) {
  // switch statement to handle different status codes
  switch (response.statusCode) {
    case 200:
      // if the status code is 200, call the onSuccess callback
      //print(response.body);
      onSuccess();
      break;
    case 201:
      // if the status code is 201, call the onSuccess callback
      onSuccess();
      break;
    case 400:
      // if the status code is 400, show a snackbar with the error message
      showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 404:
      // if the status code is 404, show a snackbar with the error message
      showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 500:
      // if the status code is 500, show a snackbar with the error message
      showSnackBar(context, json.decode(response.body)['error']);
      break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
      content: Text(title),
      // backgroundColor: Colors.red,
    ),
  );
}
