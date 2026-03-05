import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/trabajo_logic.dart';
import 'ui/screens/trabajo_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrabajoLogic()),
        // ... otros providers
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosaico App',
      initialRoute: '/trabajo', // Ajusta esto según tu flujo
      routes: {
        '/trabajo': (context) => const TrabajoScreen(),
        // ... otras rutas
      },
    );
  }
}