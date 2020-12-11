// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import './auth.dart';
// import './signup.dart';

// class SignInPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sign in Form"),
//       ),
//       body: Column(
//         children: [
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
//               context.read<AuthenticationService>().signIn(
//                     email: emailController.text.trim(),
//                     password: passwordController.text.trim(),
//                   );
//             },
//             child: Text("Sign in"),
//           ),
//           RaisedButton(
//             onPressed: () {
//               context.read<AuthenticationService>().signOut();
//             },
//             child: Text("SIGN OUT"),
//           ),
//           RaisedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpPage()),
//               );
//             },
//             child: Text("Sign Up Here"),
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
