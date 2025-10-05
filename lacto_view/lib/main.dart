// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/milk_collection/view_models/view_models.dart';
import 'features/milk_collection/views/views.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o ChangeNotifierProvider para disponibilizar o ViewModel
    // para a tela MilkCollectionListView e seus descendentes.
    return ChangeNotifierProvider(
      create: (context) => MilkCollectionViewModel(),
      child: MaterialApp(
        title: 'LactoView Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MilkCollectionFormView(),
      ),
    );
  }
}