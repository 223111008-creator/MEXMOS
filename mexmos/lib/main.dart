import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'logic/trabajo_logic.dart';
import 'logic/accesibilidad_logic.dart';
import 'logic/configurador_logic.dart'; // Just in case Catalogo uses it
import 'ui/screens/trabajo_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/catalogo_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/mis_disenos_screen.dart';
import 'ui/app_theme.dart';
import 'logic/configurador_2d_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicialización manual de Firebase con llaves directas de la Web App
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBuvo_N9gKJfVpHm_M8twtQL-kFaNazyBw",
        authDomain: "mexmos-77559.firebaseapp.com",
        projectId: "mexmos-77559",
        storageBucket: "mexmos-77559.firebasestorage.app",
        messagingSenderId: "811931863091",
        appId: "1:811931863091:web:e2660a34391b8427647b46",
      ),
    );
  } catch (e) {
    debugPrint("Firebase no inicializado: $e");
    // Continuamos la app para que la UI funcione sin backend aún
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrabajoLogic()),
        ChangeNotifierProvider(create: (_) => AccesibilidadLogic()),
        ChangeNotifierProvider(create: (_) => ConfiguradorLogic()),
        ChangeNotifierProvider(create: (_) => Configurador2DLogic()),
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
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();

    return MaterialApp(
      title: 'Mosaico App',
      theme: accesibilidadLogic.altoContraste
          ? AppTheme.highContrastDarkTheme
          : AppTheme.darkTheme,
      builder: (context, child) {
        return MediaQuery(
          // Escala global para textos y UI
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accesibilidadLogic.escalaTexto),
          ),
          child: child!,
        );
      },
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/catalogo': (context) => const CatalogoScreen(),
        '/trabajo': (context) => const TrabajoScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/mis_disenos': (context) => const MisDisenosScreen(),
        // ... otras rutas
      },
    );
  }
}
