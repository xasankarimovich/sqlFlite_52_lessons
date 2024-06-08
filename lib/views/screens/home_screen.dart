import 'package:flutter/material.dart';

import '../../services/local_database.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final localDatabase = LocalDatabase();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final db = localDatabase.database;
    print(db);
  }

  void addNote() async {
    setState(() {
      isLoading = true;
    });
    localDatabase.addNote("Bugun Bayram");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App bar bor"),
        actions: [
          IconButton.filled(
            onPressed: addNote,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child:
        !isLoading ? const CircularProgressIndicator() : const Text("Notes"),
      ),
    );
  }
}
