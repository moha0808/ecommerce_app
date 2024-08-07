import 'dart:ui';

import 'package:ecommerce_app/openpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home_page.dart';
import 'product.dart';
import 'cart_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Openpage(),
      ),
    );
  }
}
