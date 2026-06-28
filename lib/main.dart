import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
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
    // On iOS and macOS, setting fontFamily to null lets Flutter use the
    // native San Francisco font automatically. On other platforms we
    // fall back to the default system font.
    final String? systemFont =
        (Platform.isIOS || Platform.isMacOS) ? null : null;

    return MaterialApp(
      title: 'forlifey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: GlassTheme.primaryAccent,
        scaffoldBackgroundColor: GlassTheme.backgroundColor,
        // null = use platform default: San Francisco on iOS/macOS,
        // Roboto on Android, system-ui on web.
        fontFamily: systemFont,
        // Apply Apple HIG text scale throughout the app
        textTheme: _sfTextTheme(),
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

/// Builds a Material [TextTheme] that mirrors the Apple Human Interface
/// Guidelines type scale.  On iOS/macOS Flutter will automatically render
/// these styles using San Francisco; on other platforms the system default
/// applies.
TextTheme _sfTextTheme() {
  // Large Title  – 34 pt  Bold
  const largeTitleStyle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    color: GlassTheme.textPrimary,
  );
  // Title 1  – 28 pt  Bold
  const title1Style = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.36,
    color: GlassTheme.textPrimary,
  );
  // Title 2  – 22 pt  SemiBold
  const title2Style = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.35,
    color: GlassTheme.textPrimary,
  );
  // Title 3  – 20 pt  Regular
  const title3Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.38,
    color: GlassTheme.textPrimary,
  );
  // Headline  – 17 pt  SemiBold
  const headlineStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    color: GlassTheme.textPrimary,
  );
  // Body  – 17 pt  Regular
  const bodyStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    color: GlassTheme.textPrimary,
  );
  // Callout  – 16 pt  Regular
  const calloutStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    color: GlassTheme.textPrimary,
  );
  // Subheadline  – 15 pt  Regular
  const subheadStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    color: GlassTheme.textPrimary,
  );
  // Footnote  – 13 pt  Regular
  const footnoteStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: GlassTheme.textPrimary,
  );
  // Caption 1  – 12 pt  Regular
  const caption1Style = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: GlassTheme.textPrimary,
  );
  // Caption 2  – 11 pt  Regular
  const caption2Style = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    color: GlassTheme.textPrimary,
  );

  return const TextTheme(
    displayLarge: largeTitleStyle,
    displayMedium: title1Style,
    displaySmall: title2Style,
    headlineMedium: title3Style,
    headlineSmall: headlineStyle,
    titleLarge: headlineStyle,
    titleMedium: bodyStyle,
    titleSmall: calloutStyle,
    bodyLarge: bodyStyle,
    bodyMedium: calloutStyle,
    bodySmall: subheadStyle,
    labelLarge: headlineStyle,
    labelMedium: footnoteStyle,
    labelSmall: caption1Style,
  );
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
