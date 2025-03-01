import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app/controllers/graph_controller.dart';
import 'app/views/graph_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1250, 750),
    size: Size(1250, 750),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
  );
  windowManager.setTitle("Algoritmi in Optimizare Combinatorie");
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Color.lerp(Colors.black, Colors.blue, 0.25)!)),
      home: GraphScreen(
        controller: GraphController(),
      ),
    );
  }
}
