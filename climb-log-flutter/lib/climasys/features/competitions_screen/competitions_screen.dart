import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/competitions_screen/models/get_competition_by_gym_query_response.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/create_competitions/create_competition.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/gym_competitions/gym_competitions.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Import your models and api client
// import 'models.dart'; // Ensure you have the models from previous steps
// import 'competition_api_client.dart'; // Your implemented CompetitionApiClient

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  CompetitionsScreenState createState() => CompetitionsScreenState();
}

class CompetitionsScreenState extends State<CompetitionsScreen> {
  List<GetCompetitionByGymQueryResponse> competitionsByGym = [];
  String gymName = "";
  bool isLoading = true;
  bool isGymAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String foundGymName = await getGymName(context);
    isGymAdmin = await isUserGymAdmin(gymName: foundGymName);
    setState(() {
      isLoading = true;
      gymName = foundGymName;
    });

    try {
      final gymComps = await getCompetitionsByGym(gymName);

      setState(() {
        competitionsByGym = gymComps;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching competitions')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCreateCompetitionDialog() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateCompetition(refreshCompetitions: _fetchData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitions'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                GymCompetitions(
                    competitionsByGym: competitionsByGym,
                    gymName: gymName,
                    isGymAdmin: isGymAdmin,
                    refreshCompetitions: _fetchData)

              ],
            ),
      bottomNavigationBar: isGymAdmin
          ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create a New Competition'),
              onPressed: _showCreateCompetitionDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // makes button full width
              ),
            ),
          )
          : null,
    );
  }
}
