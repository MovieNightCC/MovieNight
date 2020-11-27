import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'Screens/swiper.dart';
import 'routes.dart';

import './Screens/auth.dart';
import './Screens/home_page.dart';
import './Screens/sign_in.dart';
import './Screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: "Movie Night",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.grey[100]),
        home: AuthenticationWrapper(),
        routes: routes,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print(firebaseUser.email);
      return Swiper();
    }
    return SignInPage();
  }
}
