import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getCity(String city) async {
  String url =
      "https://api.openweathermap.org/geo/1.0/direct?q=$city,in&limit=1&appid=04911a8b07235b28179ace524ff01f14";
  var response = await http.get(Uri.parse(url));
  var data = jsonDecode(response.body);
  if (data.isEmpty) {
    return data;
  }
  var shared = await SharedPreferences.getInstance();
  shared.setString("city", city);

  var lat = data[0]["lat"];
  var lon = data[0]["lon"];
  var weather = await getWeather(lat, lon);
  return weather;
}

getWeather(lat, long) async {
  String url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&units=metric&exclude=minutely,hourly&appid=04911a8b07235b28179ace524ff01f14";
  var response = await http.get(Uri.parse(url));
  return jsonDecode(response.body);
}
