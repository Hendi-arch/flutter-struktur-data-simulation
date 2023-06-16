import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:struktur_data_demo/queue_screen.dart';
import 'package:struktur_data_demo/stack_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Predefined data
  static final List<Map<String, dynamic>> personData = [
    {
      'name': 'Hendi Noviansyah',
      'photoUrl': 'assets/hendi.jpeg',
    },
    {
      'name': 'Cornelius',
      'photoUrl': 'assets/placeholder.png',
    },
    {
      'name': 'Faqih',
      'photoUrl': 'assets/placeholder.png',
    },
    {
      'name': 'Taufik',
      'photoUrl': 'assets/placeholder.png',
    },
    {
      'name': 'Fattah',
      'photoUrl': 'assets/placeholder.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Stack & Queue Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                'Stack and Queue',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: Text(
                          'Stack adalah struktur data yang mengikuti prinsip LIFO (Last-In, First-Out).\nIni memungkinkan penambahan dan penghapusan elemen dari bagian atas tumpukan.',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => const StackScreen())),
                    icon: const Icon(Icons.arrow_circle_right),
                    label: const Text("Demo"),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: Text(
                          'Queue adalah struktur data yang mengikuti prinsip FIFO (First-In, First-Out).\nIni memungkinkan menambahkan elemen ke belakang dan menghapus elemen dari depan antrian.',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => const QueueScreen())),
                    icon: const Icon(Icons.arrow_circle_right),
                    label: const Text("Demo"),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Kontributor',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: personData.map((person) {
                  return Card(
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              person['photoUrl'],
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          Text(
                            person['name'],
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
