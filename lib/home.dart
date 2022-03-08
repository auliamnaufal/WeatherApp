import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int temperature = 0;
    String location = "Jakarta";
    int woeid = 1047378;

    String weather = "clear";

    String searchApiUrl =
        "https://www.metaweather.com/api/location/search/?query=";

    String locationApiUrl = "https://www.metaweather.com/api/location/";

    void fetchSearch(String input) async {
      var searchResult = await http.get(Uri.parse(searchApiUrl + input));
      var result = jsonDecode(searchResult.body)[0];
      print(result);


      setState(() {
        location = result["title"];
        woeid = result["woeid"];
      });
    }

    Future<void> fetchLocation() async {
      var locationResult =
          await http.get(Uri.parse(locationApiUrl + woeid.toString()));
      var result = jsonDecode(locationResult.body);
      var consolidatedWeather = result["consolidated_weather"];
      var data = consolidatedWeather[0];

      setState(() {
        temperature = data['the_temp'].round();
        weather = data['weather_state_name'].replaceAll(' ', '').toLowerCase();
      });
    }

    void onTextFieldSubmitted(String input) {
      fetchSearch(input);
      fetchLocation();
    }

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/$weather.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                  child: Text(temperature.toString() + " ˚C",
                      style:
                          const TextStyle(fontSize: 60, color: Colors.white)),
                ),
                Center(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    onSubmitted: (String input) {
                      onTextFieldSubmitted(input.toLowerCase());
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    decoration: const InputDecoration(
                        hintText: 'Search Location...',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
