import 'dart:convert';
import 'package:climasys/climasys/api/models/beta_video.dart';
import 'package:climasys/climasys/api/models/competition_group_response.dart';
import 'package:climasys/climasys/api/models/competition_leaderboard.dart';
import 'package:climasys/climasys/api/models/create_push_notification_for_gym_command.dart';
import 'package:climasys/climasys/api/models/get_gym_grades_by_gym_name_response.dart';
import 'package:climasys/climasys/api/models/get_main_data_view_response.dart';
import 'package:climasys/climasys/api/models/get_num_of_climbs_data_view_response.dart';
import 'package:climasys/climasys/api/models/get_points_data_view_response.dart';
import 'package:climasys/climasys/features/route_view/models/get_route_info_query_response.dart';
import 'package:climasys/climasys/api/models/log_climb_request.dart';
import 'package:climasys/climasys/api/models/move_route_request.dart';
import 'package:climasys/climasys/api/models/opening_hour.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/add_route_command.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/bulk_alter_competition_command.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/edit_route_command.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/get_info_for_upserting_route_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:climasys/utils/push_notification_service.dart';
import 'package:http/http.dart' as http;
import '../../climasys/api/models/competition.dart';
import '../../climasys/api/models/create_competition_request.dart';
import '../../climasys/api/models/facility.dart';
import '../features/competitions_screen/models/get_competition_by_gym_query_response.dart';
import '../../climasys/api/models/gym_about_details.dart';
import '../../climasys/api/models/gym_grades.dart';
import '../../climasys/api/models/login_response.dart';
import '../../climasys/api/models/personal_stats.dart';
import '../../climasys/api/models/route.dart';
import '../../climasys/api/models/gym.dart';
import 'models/sector.dart';

// Initialize secure storage
const storage = FlutterSecureStorage();
final pushNotificationService = PushNotificationService();
const baseUrl = 'http://localhost:5136';
const successStatusCodes = [200, 201, 204];

// Get Gym data
Future<Gym> getGym(String gymName) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/GetGym');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return Gym.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load gym data: ${response.reasonPhrase}');
  }
}

// Add a new route
Future<void> addRoute(AddRouteCommand command) async {
  final url = Uri.parse('$baseUrl/Route/${command.gymName}/v2/AddRoute');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.post(
      url,
      body: jsonEncode(command.toJson()),
      headers: headers
  );

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to add route: ${response.reasonPhrase}');
  }
}

// Get Gym grades
Future<GymGrades> getGymGrades(String gymName) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/GetGymGrades');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return GymGrades.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load gym grades: ${response.reasonPhrase}');
  }
}

// Get Gym grades
Future<List<String>> getAllGymNames() async {
  final url = Uri.parse('$baseUrl/Gym/GetAllGymNames');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.cast<String>();
  } else {
    throw Exception('Failed to load gym grades: ${response.reasonPhrase}');
  }
}

// Fetch all routes
Future<List<Route>> getAllRoutes(String gymName) async {
  final url = Uri.parse('$baseUrl/Route/$gymName/GetAllRoutes');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<Route> allRoutes = (jsonResponse as List<dynamic>)
        .map((routeJson) => Route.fromJson(routeJson as Map<String, dynamic>))
        .toList();

    return allRoutes;
  } else {
    throw Exception('Failed to load routes: ${response.reasonPhrase}');
  }
}

// Login function (unchanged)
Future<String> login(String username, String password) async {
  final url = Uri.parse('$baseUrl/api/Auth/login');
  print(username);
  String? currentPushToken = await pushNotificationService.getDeviceToken();

  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    'username': username,
    'password': password,
    'pushNotificationToken': currentPushToken
  });

  final response = await http.post(url, headers: headers, body: body);
  print(response);
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['token']; // Return the access token
  } else {
    throw Exception('Failed to login: ${response.reasonPhrase}');
  }
}

// Refresh access token function
Future<String> refreshAccessToken() async {
  // Retrieve the current token from secure storage
  String? accessToken = await storage.read(key: 'accessToken');
  String? currentPushToken = await pushNotificationService.getDeviceToken();

  var body = "";

  if(accessToken == null){
    return "";
  }

  if (currentPushToken != null) {
    body = jsonEncode(currentPushToken);
  }

  final url = Uri.parse('$baseUrl/api/Auth/RefreshAccessToken');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    String newToken = jsonResponse['token'];
    // Update the token in storage
    await storage.write(key: 'accessToken', value: newToken);
    return newToken;
  } else {
    //Token is invalid or user is not logged in
    return "";
  }
}

// Function to log a climb
Future<void> logClimb(LogClimbRequest request) async {
  final url = Uri.parse('$baseUrl/Climb/LogClimb');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode(request.toJson());

  print(body);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    print(response.reasonPhrase);
    throw Exception('Failed to log climb: ${response.reasonPhrase}');
  }
}

// Archive a route function
Future<void> archiveRoute(int routeId, String gymName) async {
  final url = Uri.parse('$baseUrl/Route/$gymName/ArchiveRoute');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  };

  final body = routeId.toString();

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to archive route: ${response.reasonPhrase}');
  }
}

Future<void> bulkArchiveRoutes(List<int> routeIds, String gymName) async {
  final url = Uri.parse('$baseUrl/Route/$gymName/ArchiveRoutes');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(routeIds);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to bulk archive routes: ${response.reasonPhrase}');
  }
}

// Get Personal Stats (New Function)
Future<PersonalStats> getPersonalStats(String gymName) async {
  final url = Uri.parse('$baseUrl/Dashboard/$gymName/GetPersonalStats');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return PersonalStats.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load personal stats: ${response.reasonPhrase}');
  }
}

// Register a new user
Future<void> registerUser({
  required String username,
  required String email,
  required String password,
  required String friendlyName,
}) async {
  final url = Uri.parse('$baseUrl/api/Auth/register');
  String? currentPushToken = await pushNotificationService.getDeviceToken();

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'username': username,
    'email': email,
    'password': password,
    'friendlyName': friendlyName,
    'pushNotificationToken': currentPushToken
  });

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to register user: ${response.reasonPhrase}');
  }
}

// Register a new user
Future<bool> isUserGymAdmin({required String gymName}) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/IsUserGymAdmin');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {'Authorization': 'Bearer $accessToken'};

  final response = await http.get(url, headers: headers);

  if (successStatusCodes.contains(response.statusCode)) {
    return jsonDecode(response.body) as bool;
  } else {
    throw Exception(
        'Failed to check if user is admin: ${response.reasonPhrase}');
  }
}

// Get Gym About Details (New Function)
Future<GymAboutDetails> getGymAboutDetails(String gymName) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/GetGymAboutDetails');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    if (accessToken == null) 'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return GymAboutDetails.fromJson(jsonResponse);
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<void> updateGymAddress(String gymName, String address) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/UpdateGymAddress');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response =
      await http.put(url, headers: headers, body: jsonEncode(address));

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<List<Facility>> getAllFacilities() async {
  final url = Uri.parse('$baseUrl/Facility');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<Facility> allFacilities = (jsonResponse as List<dynamic>)
        .map((facilitiesJson) =>
            Facility.fromJson(facilitiesJson as Map<String, dynamic>))
        .toList();

    return allFacilities;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<List<Facility>> getFacilitiesToShow(String gymName) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/FacilitiesToShow');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    if (accessToken == null) 'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<Facility> allFacilities = (jsonResponse as List<dynamic>)
        .map((facilitiesJson) =>
            Facility.fromJson(facilitiesJson as Map<String, dynamic>))
        .toList();

    return allFacilities;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<void> editGymFacilities(String gymName, List<int> facilityIds) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/EditGymFacilities');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response =
      await http.put(url, headers: headers, body: jsonEncode(facilityIds));

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<void> editOpeningHours(
    String gymName, List<OpeningHour> openingHours) async {
  final url = Uri.parse('$baseUrl/Gym/$gymName/UpsertDefaultGymOpeningHours');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response =
      await http.put(url, headers: headers, body: jsonEncode(openingHours));

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<void> createCompetition(CreateCompetitionRequest request) async {
  final url = Uri.parse('$baseUrl/Competition/CreateCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(request.toJson()),
  );

  if (response.statusCode == 204) {
    return;
  } else {
    throw Exception('Failed to create competition: ${response.reasonPhrase}');
  }
}

Future<List<GetCompetitionByGymQueryResponse>> getCompetitionsByGym(
    String gymName) async {
  final url = Uri.parse('$baseUrl/Competition/$gymName/GetCompetitionsByGym');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Accept': 'text/plain',
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data
        .map((e) => GetCompetitionByGymQueryResponse.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to fetch competitions: ${response.reasonPhrase}');
  }
}

// 3. GetCompetitionsByLogin
Future<List<Competition>> getCompetitionsByLogin() async {
  final url = Uri.parse('$baseUrl/Competition/GetCompetitionsByLogin');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((e) => Competition.fromJson(e)).toList();
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

// 4. EnterCompetition
Future<void> enterCompetition(int competitionGroupId) async {
  final url = Uri.parse('$baseUrl/Competition/EnterCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(competitionGroupId),
  );

  if (response.statusCode == 204) {
    return;
  } else {
    throw Exception('Failed to enter competition: ${response.reasonPhrase}');
  }
}

// 3. GetCompetitionsByLogin
Future<List<CompetitionGroupResponse>> getCompetitionGroupsByCompId(
    int id) async {
  final url = Uri.parse('$baseUrl/Competition/$id/GetCompetitionGroups');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((e) => CompetitionGroupResponse.fromJson(e)).toList();
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

// 3. GetCompetitionsByLogin
Future<void> leaveCompetitionByCompetitionId(int id) async {
  final url = Uri.parse('$baseUrl/Competition/$id/LeaveCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.delete(url, headers: headers);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

// 3. GetCompetitionsByLogin
Future<List<CompetitionLeaderboard>> getCompetitionGroupLeaderboard(
    int competitionGroupId) async {
  final url = Uri.parse(
      '$baseUrl/Competition/$competitionGroupId/GetCompetitionGroupLeaderboard');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.get(url, headers: headers);

  if (successStatusCodes.contains(response.statusCode)) {
    final data = jsonDecode(response.body) as List;
    return data.map((e) => CompetitionLeaderboard.fromJson(e)).toList();
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

// Get Gym grades
Future<List<String>> getAllGymsWhereUserIsAdmin() async {
  final url = Uri.parse('$baseUrl/Gym/GetAllGymsWhereUserIsAdmin');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.cast<String>();
  } else {
    throw Exception('Failed to load gym grades: ${response.reasonPhrase}');
  }
}

Future<void> startCompetition(int id) async {
  final url = Uri.parse('$baseUrl/Competition/StartCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(id);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

Future<void> stopCompetition(int id) async {
  final url = Uri.parse('$baseUrl/Competition/StopCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(id);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

Future<void> archiveCompetition(int id) async {
  final url = Uri.parse('$baseUrl/Competition/ArchiveCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(id);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception(
        'Failed to fetch competitions by login: ${response.reasonPhrase}');
  }
}

Future<void> addGymAdmin(String gymName, int userId) async {
  final url = Uri.parse('$baseUrl/Admin/$gymName/AddGymAdmin');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(userId);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to add gym admin: ${response.reasonPhrase}');
  }
}

Future<void> removeGymAdmin(String gymName, int userId) async {
  final url = Uri.parse('$baseUrl/Admin/$gymName/RemoveGymAdmin');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(userId);

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to remove gym admin: ${response.reasonPhrase}');
  }
}

Future<List<LoginResponse>> searchLoginsByString(
    String gymName, String searchString) async {
  final url = Uri.parse('$baseUrl/Admin/$gymName/SearchLoginsByString')
      .replace(queryParameters: {'SearchString': searchString});

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((item) => LoginResponse.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to retrieve logins ${response.reasonPhrase}');
  }
}

Future<void> deleteAccount(String username, String password) async {
  final url = Uri.parse('$baseUrl/api/Auth/DeleteLogin');

  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    'username': username,
    'password': password,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to delete login: ${response.reasonPhrase}');
  }
}

Future<List<GetMainDataViewResponse>> getMainDataView(String gymName) async {
  final url = Uri.parse('$baseUrl/Dashboard/$gymName/GetMainDataView');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((item) =>
            GetMainDataViewResponse.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to retrieve logins ${response.reasonPhrase}');
  }
}

Future<void> unlogClimb(int id) async {
  final url = Uri.parse('$baseUrl/Climb/$id/UnlogClimb');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'text/plain',
    'Content-Type': 'application/json'
  };

  final response = await http.delete(url, headers: headers);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to unlog climb: ${response.reasonPhrase}');
  }
}

Future<List<GetNumOfClimbsDataViewResponse>> getNumOfClimbsDataView(
    String gymName) async {
  final url = Uri.parse('$baseUrl/Dashboard/$gymName/GetNumOfClimbsDataView');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((item) => GetNumOfClimbsDataViewResponse.fromJson(
            item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to retrieve logins ${response.reasonPhrase}');
  }
}

Future<List<GetPointsDataViewResponse>> getPointsDataView(
    String gymName) async {
  final url = Uri.parse('$baseUrl/Dashboard/$gymName/GetPointsDataView');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((item) =>
            GetPointsDataViewResponse.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to retrieve logins ${response.reasonPhrase}');
  }
}

Future<void> createPushNotificationForGym(CreatePushNotificationForGymCommand command) async {
  final url = Uri.parse('$baseUrl/PushNotification/CreatePushNotificationByGymName');

  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(command.toJson());

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to send push Notification: ${response.reasonPhrase}');
  }
}

Future<List<Sector>> getSectorsByGymName(String gymName) async {
  final url = Uri.parse('$baseUrl/Sector/$gymName/GetSectorsByGymName');

  final headers = {
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<Sector> sectors = (jsonResponse as List<dynamic>)
        .map((sectorsJson) =>
        Sector.fromJson(sectorsJson as Map<String, dynamic>))
        .toList();

    return sectors;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<void> moveRoute(MoveRouteRequest request, String gymName) async {
  final url = Uri.parse('$baseUrl/Route/$gymName/MoveRoute');

  String? accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw Exception('No access token found. Please log in.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode(request.toJson());

  final response = await http.post(url, headers: headers, body: body);

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to send push Notification: ${response.reasonPhrase}');
  }
}

Future<List<BetaVideo>> getBetaVideosByRouteId(int routeId) async {
  final url = Uri.parse('$baseUrl/BetaVideo/$routeId/GetBetaVideos');

  final headers = {
    'Accept': 'text/plain'
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<BetaVideo> sectors = (jsonResponse as List<dynamic>)
        .map((betaVideosJson) =>
        BetaVideo.fromJson(betaVideosJson as Map<String, dynamic>))
        .toList();

    return sectors;
  } else {
    throw Exception(
        'Failed to load gym about details: ${response.reasonPhrase}');
  }
}

Future<GetInfoForUpsertingRouteQueryResponse> getInfoForUpsertingRoute(int? routeId, String gymName) async {
  try {
    print("This prints");
    final url = Uri.parse('$baseUrl/Route/$gymName/GetInfoForAlteringRoute')
        .replace(queryParameters: {'existingRouteId': routeId?.toString(), 'gymName': gymName});

    final headers = {
      'Accept': 'text/plain'
    };

    final response = await http.get(url, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = GetInfoForUpsertingRouteQueryResponse.fromJson(
          jsonResponse);

      return result;
    } else {
      throw Exception(
          'Failed to load gym about details: ${response.reasonPhrase}');
    }
  }
  catch(e){
    print(e);
    rethrow;
  }
}

Future<void> editRoute (EditRouteCommand command, String gymName) async {
  try {
    final url = Uri.parse('$baseUrl/Route/$gymName/EditRoute');

    String? accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };


    final response = await http.post(
      url,
      body: jsonEncode(command.toJson()),
      headers: headers
    );

    if (successStatusCodes.contains(response.statusCode)) {
      return;
    } else {
      throw Exception(
          'Failed to edit route: ${response.reasonPhrase}');
    }
  }
  catch(e){
    throw Exception();
  }
}

Future<GetRouteInfoQueryResponse> getRouteInfo(int routeId) async {
  try {
    final url = Uri.parse('$baseUrl/Route/$routeId/GetRouteInfo');

    final headers = {
      'Accept': 'text/plain'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      final result = GetRouteInfoQueryResponse.fromJson(jsonResponse);
      return result;
    } else {
      throw Exception(
          'Failed to load gym about details: ${response.reasonPhrase}');
    }
  }
  catch(e){
    throw Exception();
  }
}

Future<GetGymGradesByGymNameResponse> getGymGradesByGymName(String gymName) async {
  try {
    final url = Uri.parse('$baseUrl/Grade/$gymName/GetGymGrades');

    final headers = {
      'Accept': 'text/plain'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = GetGymGradesByGymNameResponse.fromJson(jsonResponse);
      return result;
    } else {
      throw Exception(
          'Failed to load gym about details: ${response.reasonPhrase}');
    }
  }
  catch(e){
    throw Exception();
  }
}

Future<String> loginWithSocial(String provider, String idToken, String? friendlyName) async {
  String? currentPushToken = await pushNotificationService.getDeviceToken();

  final response = await http.post(
    Uri.parse('$baseUrl/api/Auth/LoginWithSocial'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'provider': provider,
      'idToken': idToken,
      'friendlyName': friendlyName,
      'pushNotificationToken': currentPushToken
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Social Login failed');
  }
}

// Add a new route
Future<void> bulkAlterCompetition(BulkAlterCompetitionCommand command, String gymName) async {
  final url = Uri.parse('$baseUrl/Route/$gymName/BulkAlterCompetition');

  // Retrieve the access token
  String? accessToken = await storage.read(key: 'accessToken');

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.post(
      url,
      body: jsonEncode(command.toJson()),
      headers: headers
  );

  if (successStatusCodes.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to add route: ${response.reasonPhrase}');
  }
}