import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

var responseObject = ResponseData();

class ApiCall {
  Future fetchWeather(var lat, var lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&exclude=alerts,minutely&appid=0f8c88146a435b8db9d6af1cacbbc02a'));
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      responseObject = ResponseData.fromJson(jsonDecode(response.body));
      // return ResponseData.fromJson(jsonDecode(response.body));
    } else {
      print(responseData);
      throw Exception('Failed to load Weather');
    }
  }
}
