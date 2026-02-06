import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Persona App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blue[200],
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2.0,
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineSmall: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      home: const HomePage(),
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
  const HomePage({super.key});

  static const List<Persona> personas = [
    Persona(
      name: 'Financial Advisor',
      icon: Icons.attach_money,
      expertise: 'financial planning and investment',
    ),
    Persona(
      name: 'Wellness Coach',
      icon: Icons.fitness_center,
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
      icon: Icons.book,
      expertise: 'biblical studies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your AI Persona',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          itemCount: personas.length,
          itemBuilder: (context, index) {
            final persona = personas[index];
            return InkWell(
              onTap: () {
                if (persona.name == 'Financial Advisor' ||
                    persona.name == 'Relationship Expert' ||
                    persona.name == 'Wellness Coach' ||
                    persona.name == 'Psychiatrist' ||
                    persona.name == 'McArthur Bible Commentary') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(persona: persona),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonaPage(persona: persona),
                    ),
                  );
                }
              },
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(persona.icon, size: 48.0, color: Colors.blue[700]),
                    const SizedBox(height: 8.0),
                    Text(
                      persona.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
