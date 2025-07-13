import 'dart:convert';
import 'package:climasys/climasys/features/account_view/models/edit_account_details_request.dart';
import 'package:climasys/climasys/features/account_view/models/get_account_details_query_response.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<GetAccountDetailsQueryResponse> getAccountDetails() async {
  final url = Uri.parse('$configApiBaseUrl/Account/GetAccountDetails');
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return GetAccountDetailsQueryResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to retrieve account Details: ${response.reasonPhrase}');
  }
}

Future<void> postUpdatedProfilePicture(XFile pickedFile) async {
  final url = Uri.parse('$configApiBaseUrl/Account/UpdateProfilePicture');

  final accessToken = await getAccessToken();

  final request = http.MultipartRequest('POST', url)
    ..headers.addAll({
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    })
    ..files.add(await http.MultipartFile.fromPath(
      'profilePicture', // must match .NET API param name
      pickedFile.path,
    ));

  final response = await request.send();

  if (!configApiSuccessResponses.contains(response.statusCode)) {
    final respStr = await response.stream.bytesToString();
    throw Exception('Failed to upload profile picture: $respStr');
  }
}

// Add a new route
Future<void> editAccountDetails(EditAccountDetailsRequest request) async {
  final url = Uri.parse('$configApiBaseUrl/Account/EditAccountDetails');

  // Retrieve the access token
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await http.post(
      url,
      body: jsonEncode(request.toJson()),
      headers: headers
  );

  if (configApiSuccessResponses.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to edit account details: ${response.reasonPhrase}');
  }
}