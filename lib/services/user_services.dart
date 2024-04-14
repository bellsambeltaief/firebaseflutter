import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class UserService {
 // Method for user login
  Future<dynamic> loginUser(String email, String password) async {
    var response = await http.post(
      Uri.parse('${Config.apiUrl}login/'),  // Adjust the URL based on your backend endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);}
      dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);  // Assuming a token or user data is returned
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
  
 // Method for user create
  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    var uri = Uri.parse('${Config.apiUrl}signup/');
    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = userData['email']
      ..fields['password'] = userData['password']
      ..fields['cin'] = userData['cin'];

  

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }
  Future<dynamic> updateUser(int id, Map<String, dynamic> userData) async {
    var response = await http.put(
      Uri.parse('${Config.apiUrl}users/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    _handleResponse(response);
  }

  Future<dynamic> deleteUser(int id) async {
    var response = await http.delete(
      Uri.parse('${Config.apiUrl}users/$id/'),
    );
    _handle(response);
  }

  dynamic _handle(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process request: ${response.body}');
    }
  }
}