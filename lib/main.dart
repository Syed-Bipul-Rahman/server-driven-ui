import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'sdui_parser.dart';

void main() {
  runApp(const ServerDrivenUIApp());
}

class ServerDrivenUIApp extends StatelessWidget {
  const ServerDrivenUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server-Driven UI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SDUIHomePage(),
    );
  }
}

class SDUIHomePage extends StatefulWidget {
  const SDUIHomePage({super.key});

  @override
  State<SDUIHomePage> createState() => _SDUIHomePageState();
}

class _SDUIHomePageState extends State<SDUIHomePage> {
  final SDUIParser _parser = SDUIParser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Server-Driven UI Demo'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadUIConfig(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorUI(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildFallbackUI();
          }

          try {
            final widget = _parser.parseWidget(snapshot.data!);
            return widget ?? _buildFallbackUI();
          } catch (e) {
            return _buildErrorUI('Error parsing UI: $e');
          }
        },
      ),
    );
  }

  // Load JSON configuration from assets
  Future<Map<String, dynamic>> _loadUIConfig() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/ui_config.json');
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load UI configuration: $e');
    }
  }

  // Fallback UI when JSON fails to load or parse
  Widget _buildFallbackUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.orange,
          ),
          SizedBox(height: 16),
          Text(
            'Fallback UI',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'UI configuration could not be loaded.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Error UI for when something goes wrong
  Widget _buildErrorUI(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error Loading UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}