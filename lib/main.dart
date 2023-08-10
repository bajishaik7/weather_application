import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //testing
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            // HomeScreen(),
            Scaffold(
          backgroundColor: Colors.grey,
          body: FutureBuilder(
              future: Future.delayed(Duration(seconds: 8)),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  return HomeScreen();
                } else {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        SizedBox(
                            // height: 200,
                            // width: 70,
                            child: LottieBuilder.asset("assets/wind-day.json")),
                        LottieBuilder.asset("assets/weather_welcome_text.json"),
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}
