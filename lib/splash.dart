import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newweather/newpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Newpage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303644),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/weather.json"),
          Text(
            "Weather App",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
          )
        ],
      )),
    );
  }
}
