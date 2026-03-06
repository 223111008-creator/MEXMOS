import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/trabajo_logic.dart';
import 'logic/accesibilidad_logic.dart';
import 'logic/configurador_logic.dart';
import 'ui/screens/trabajo_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/catalogo_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrabajoLogic()),
        ChangeNotifierProvider(create: (_) => AccesibilidadLogic()),
        ChangeNotifierProvider(create: (_) => ConfiguradorLogic()),
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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/catalogo': (context) => const CatalogoScreen(),
        '/trabajo': (context) => const TrabajoScreen(),
        // ... otras rutas
      },
    );
  }
}
