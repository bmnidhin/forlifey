import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/app_state.dart';
import 'theme/glass_theme.dart';
import 'widgets/liquid_background.dart';
import 'widgets/floating_nav_bar.dart';
import 'screens/checklists_screen.dart';
import 'screens/discover_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait for a better mobile experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system navigation overlay styles (dark icons for light mode)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark, // For Android (dark icons)
  ));

  runApp(
    AppStateProvider(
      notifier: AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forlifey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: GlassTheme.primaryAccent,
        scaffoldBackgroundColor: GlassTheme.backgroundColor,
        fontFamily: '.SF Pro Text', // Standard system font
        colorScheme: ColorScheme.fromSeed(
          seedColor: GlassTheme.primaryAccent,
          brightness: Brightness.light,
          background: GlassTheme.backgroundColor,
        ),
      ),
      home: const MainNavigationController(),
    );
  }
}

class MainNavigationController extends StatefulWidget {
  const MainNavigationController({super.key});

  @override
  State<MainNavigationController> createState() => _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return LiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Tab contents
            IndexedStack(
              index: _currentIndex,
              children: [
                ChecklistsScreen(
                  instances: state.instances,
                  onExplorePressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                DiscoverScreen(
                  templates: state.templates,
                ),
              ],
            ),
            // Floating navigation bar at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingNavBar(
                currentIndex: _currentIndex,
                onTabSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
