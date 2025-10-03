import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/course_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'services/auth_service.dart';
import 'services/course_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(AuthService())),
        ChangeNotifierProvider(create: (_) => CourseController(CourseService())),
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: const LMSApp(),
    ),
  );
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MaterialApp(home: SignupPage()));
//
// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//   // Put your Zoho details here
//   final ownerName = "killionchase909";
//   final appName = "savemore-lms";
//   final accessToken = "1000.ced0a4664e2d42b0b64e17f96425a8d5.246788006f9086752c2b3d8aaf63c53c"; // Replace with valid token
//
//   Future<void> signup() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }
//
//     final url =
//         "https://creator.zoho.com/api/v2/$ownerName/$appName/form/Students/record";
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Authorization": "Zoho-oauthtoken $accessToken",
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "data": {
//           "First_Name": firstNameController.text,
//           "Last_Name": lastNameController.text,
//           "Email": emailController.text,
//           "Password": passwordController.text,
//         }
//       }),
//     );
//
//     print("Signup response: ${response.body}");
//
//     final data = jsonDecode(response.body);
//     if (data["code"] == 3000) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Signup Successful ✅")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Signup Failed ❌: ${data['description']}")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Signup")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: firstNameController,
//               decoration: InputDecoration(labelText: "First Name"),
//             ),
//             TextField(
//               controller: lastNameController,
//               decoration: InputDecoration(labelText: "Last Name"),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             TextField(
//               controller: confirmPasswordController,
//               decoration: InputDecoration(labelText: "Confirm Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: signup,
//               child: Text("Signup"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
