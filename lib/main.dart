import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/auth%20screens/splash_screen.dart';
import 'package:muzahir_fyp/viewModel/authViewModel.dart';
import 'package:muzahir_fyp/viewModel/googleMapViewModel.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleMapViewModel(),
        ),
    ],
    child: MaterialApp(
 theme: ThemeData(
             primarySwatch: Colors.teal,
        colorScheme: const ColorScheme.light(
          primary: primaryColor, // Header background color
          onPrimary: Colors.white, // Header text color
          onSurface: Colors.black, // Body text color
        ),    
         
            useMaterial3: true,
          ),        debugShowCheckedModeBanner: false,
        home: const SplashScreen()
        
        
        ),
    );
    
    
    
  }
}
