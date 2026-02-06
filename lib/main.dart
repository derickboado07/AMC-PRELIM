import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Persona App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: const Text('Select Your AI Persona'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonaPage(persona: persona),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      persona.icon,
                      size: 48.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      persona.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
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
        title: Text(persona.name),
      ),
      body: Center(
        child: Text(
          'This persona will answer questions related to ${persona.expertise}.',
          style: const TextStyle(fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
