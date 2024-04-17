import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart/models/m_login.dart';
const String serverApi = "http://127.0.0.1:8000/api/v1";



class UserService {
  // Method for user login
  Future<dynamic> loginUserWithModel(MLogin loginModel) async {
    var response = await http.post(
      Uri.parse('http://$serverApi/accounts/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginModel.toMap()), // Convert MLogin object to JSON
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody); // Print the response body
      return responseBody;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Method for user registration
  Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    var uri = Uri.parse('http://$serverApi/accounts/register/');
    var request = http.MultipartRequest('POST', uri)
      ..fields['client_ID '] = userData['client_ID ']
      ..fields['client_Name'] = userData['client_Name']
      ..fields['client_email '] = userData['client_email ']
      ..fields['client_CIN'] = userData['client_CIN'];

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody); // Print the response body
      return responseBody;
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // Other methods for user management...
}
