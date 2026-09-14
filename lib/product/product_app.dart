import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'fanvura_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FanvuraStore(),
      child: MaterialApp(
        title: 'Fanvura',
        home: const FanvuraHome(),
      ),
    );
  }
}
