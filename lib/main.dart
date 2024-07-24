import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicapp/utilits/constants/constant.dart';
import 'package:musicapp/utilits/appRouter.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      "An error has been occured ${snapshot.error}"),
                ),
              );
            }
            return MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: kPrimaryColor,
                textTheme:
                    GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
              ),
            );
          }),
    );
  }
}
