// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class FileModel {
//   final int id;
//   final String fileName;
//   final String uploadedAt;

//   FileModel({required this.id, required this.fileName, required this.uploadedAt});

//   factory FileModel.fromJson(Map<String, dynamic> json) {
//     return FileModel(
//       id: json['id'],
//       fileName: json['file_name'],
//       uploadedAt: json['uploaded_at'],
//     );
//   }
// }

// class ApiService {
//   static const String baseUrl = 'http://your-django-api-url.com/';

//   Future<List<FileModel>> fetchFiles() async {
//     final response = await http.get(Uri.parse(baseUrl + 'files/'));
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body);
//       return jsonData.map((item) => FileModel.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to fetch files');
//     }
//   }

//   Future<FileModel> uploadFile(String filePath, String uid, String email, String name) async {
//     final uri = Uri.parse(baseUrl + 'files/');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['user'] = uid;
//     request.fields['email'] = email;
//     request.fields['name'] = name;
//     request.files.add(await http.MultipartFile.fromPath('file', filePath));

//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//     if (response.statusCode == 201) {
//       return FileModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to upload file');
//     }
//   }

//   Future<void> deleteFile(int fileId) async {
//     final response = await http.delete(Uri.parse(baseUrl + 'files/$fileId/'));
//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete file');
//     }
//   }
// }