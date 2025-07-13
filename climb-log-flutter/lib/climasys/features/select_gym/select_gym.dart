import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:flutter/material.dart';
import '../map_view/map_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Placeholder for the storage instance
// Replace with your actual storage implementation
const storage = FlutterSecureStorage();

class SelectGym extends StatefulWidget {
  const SelectGym({super.key});

  @override
  State<SelectGym> createState() => _SelectGymState();
}

class _SelectGymState extends State<SelectGym> {
  List<String> _gymNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGymNames();
  }

  Future<void> _fetchGymNames() async {
    List<String> gymNames = await getAllGymNames();
    setState(() {
      _gymNames = gymNames;
      _isLoading = false;
    });
  }

  Future<void> _selectGym(String gymName) async {
    await storage.write(key: 'gymName', value: gymName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected gym: $gymName')),
    );

    // Navigate to MapView and replace the current route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Select a Gym'), automaticallyImplyLeading: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _gymNames.length,
              itemBuilder: (context, index) {
                final gymName = _gymNames[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(gymName),
                    onTap: () => _selectGym(gymName),
                  ),
                );
              },
            ),
    );
  }
}
