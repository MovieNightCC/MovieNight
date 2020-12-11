import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// import './auth.dart';
// import './addPairPage.dart';

// class SignUpPage extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sign Up Form"),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: nameController,
//             decoration: InputDecoration(
//               labelText: "Name",
//             ),
//           ),
//           TextField(
//             controller: emailController,
//             decoration: InputDecoration(
//               labelText: "Email",
//             ),
//           ),
//           TextField(
//             controller: passwordController,
//             decoration: InputDecoration(
//               labelText: "Password",
//             ),
//           ),
//           RaisedButton(
//             onPressed: () {
//               context.read<AuthenticationService>().signUp(
//                     email: emailController.text.trim(),
//                     password: passwordController.text.trim(),
//                   );

//               _postUser(
//                   emailController.text.trim(), nameController.text.trim());
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => AddPairPage(),
//                       maintainState: true));
//             },
//             child: Text("Sign Up"),
//           ),
//           RaisedButton(
//             onPressed: () {
//               launch('https://movie-night.flycricket.io/privacy.html');
//             },
//             child: Text("Privacy Policy"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _postUser(String email, String name) async {
//   //convert username here eviljose@gmail.com => eviljose
//   var userName = email.substring(0, email.indexOf("@"));
//   Map<String, String> queryParams = {
//     'userName': userName,
//     'name': name,
//     'email': email,
//   };

//   print(queryParams);
//   var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
//       "/createUser", queryParams);

//   var response = await http.post(uri);
//   print('response status: ${response.statusCode}');
//   print('response body ${response.body}');
// }
