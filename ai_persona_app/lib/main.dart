import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'screens/chat_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/persona_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppTheme.primaryDark,
      scaffoldBackgroundColor: const Color(0xFF0B0B0B),
      cardColor: const Color(0xFF1C1C1E),
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class Persona {
  final String name;
  final IconData icon;
  final String expertise;

  const Persona({
    required this.name,
    required this.icon,
    required this.expertise,
  });
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({super.key, required this.toggleTheme, required this.isDarkMode});

  static const List<Persona> personas = [
    Persona(
      name: 'Financial Advisor',
      icon: Icons.trending_up,
      expertise: 'financial planning and investment',
    ),
    Persona(
      name: 'Wellness Coach',
      icon: Icons.self_improvement,
      expertise: 'health and wellness',
    ),
    Persona(
      name: 'Psychiatrist',
      icon: Icons.psychology,
      expertise: 'mental health',
    ),
    Persona(
      name: 'Relationship Expert',
      icon: Icons.favorite,
      expertise: 'relationships',
    ),
    Persona(
      name: 'McArthur Bible Commentary',
      icon: Icons.menu_book,
      expertise: 'biblical studies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.of(context);
    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 🎪 Expandable SliverAppBar
          SliverAppBar(
            expandedHeight: 220,
            floating: true,
            snap: true,
            backgroundColor: palette.surfaceColor,
            elevation: 0,
            leading: const SizedBox.shrink(),
            actions: [
              IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: toggleTheme,
                color: palette.textPrimary,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      palette.primaryColor.withOpacity(0.08),
                      palette.accentColor.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎯 Main Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingXL,
                        vertical: AppTheme.paddingLG,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Choose Your',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                              letterSpacing: -1.0,
                            ),
                          ),
                          Text(
                            'Companion',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: palette.primaryColor,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 📝 Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingXL,
                      ),
                      child: Text(
                        'Select an AI expert to start your personalized conversation',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: palette.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: EdgeInsets.zero,
              centerTitle: true,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
                child: Container(
                height: 1,
                color: palette.dividerColor.withOpacity(0.5),
              ),
            ),
          ),

          // 🎴 Persona Grid
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.paddingLG),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.paddingLG,
                mainAxisSpacing: AppTheme.paddingLG,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final persona = personas[index];
                  return PersonaCard(
                    name: persona.name,
                    icon: persona.icon,
                    subtitle: persona.expertise,
                    index: index,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(persona: persona, toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                        ),
                      );
                    },
                  );
                },
                childCount: personas.length,
              ),
            ),
          ),

          // 🎯 Bottom Padding
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppTheme.paddingXL),
          ),
        ],
      ),
    );
  }
}

class PersonaPage extends StatelessWidget {
  final Persona persona;

  const PersonaPage({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          persona.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Center(
        child: Text(
          'This persona will answer questions related to ${persona.expertise}.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
