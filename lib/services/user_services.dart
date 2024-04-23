// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:smart/models/m_login.dart';
// import 'package:smart/models/m_sign_up.dart';

// const String serverApi = "http://172.20.10.3:8000/api/client";



// class UserService {
//   // Method for user login
//   Future<dynamic> loginUserWithModel(MLogin loginModel) async {
//     var response = await http.post(
//       Uri.parse('$serverApi/login/'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(loginModel.toMap()), // Convert MLogin object to JSON
//     );
//     return _handleResponse(response);
//   }

//   dynamic _handleResponse(http.Response response) {
//     if (response.statusCode == 200) {
//       var responseBody = jsonDecode(response.body);
//       print(responseBody); // Print the response body
//       return responseBody;
//     } else {
//       throw Exception('Failed to login: ${response.body}');
   
//     }
//   }

//   // Method for user registration
//   Future<dynamic> registerUser(MSignUpUser userData) async {
//     var uri = Uri.parse('$serverApi/signup');
//     var response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(userData.toMap()), // Convert MSignUpUser object to JSON
//     );

//     if (response.statusCode == 200) {
//       var responseBody = jsonDecode(response.body);
//       print(responseBody); // Print the response body
//       return responseBody;
//     } else {
//       throw Exception('Failed to register user: ${response.body}');
//     }
//   }

//   // Other methods for user management...
// }