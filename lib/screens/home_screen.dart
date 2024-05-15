import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts/consts.dart';
import 'package:weather_app/splash/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _wl = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wl.currentWeatherByCityName("Nepal").then((w) => {
          setState(() {
            _weather = w;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather app"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.green])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _weather?.areaName ?? "",
        onChanged: (String? newValue) {
          if (newValue != null) {
            _fetchWeatherData(newValue);
          }
        },
        items: <String>['Nepal', 'China', 'Dubai']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        underline: const SizedBox(),
      ),
    );
  }

  Future<void> _fetchWeatherData(String location) async {
    try {
      Weather weather = await _wl.currentWeatherByCityName(location);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      //print("Error fetching weather data: $e");
    }
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm: a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                // fontSize: 23,

                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      " ${_weather?.temperature?.celsius?.toStringAsFixed(0)}°c",
      style: const TextStyle(
        fontSize: 30,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max:  ${_weather?.tempMax?.celsius?.toStringAsFixed(0)} °c",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°c",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "wind:  ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
