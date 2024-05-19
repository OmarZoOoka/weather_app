import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_ui/cubit/get_weather_cubit.dart';
import 'package:weather_ui/screens/search_screen.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  final TextEditingController _textFormController = TextEditingController();
  String location = "Null, Press The Button";
  String Address = 'Search';
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      print('');
    }
    permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Flushbar(
          messageText: Text(
            "Please Allow The Location :)",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          borderColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: Duration(seconds: 3),
        ).show(context);
        permission = await Geolocator.requestPermission();
      }
    }

    if (permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetCity(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark city = placemark[0];
    Address = '${city.subAdministrativeArea}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Search a City",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _textFormController,
                onFieldSubmitted: (cityName) async {
                  BlocProvider.of<GetWeatherCubit>(context)
                      .getWeather(cityName: cityName);
                  Navigator.pop(context);
                },
                decoration: InputDecoration(
                  hintText: "Enter City Name",
                  labelText: "Search",
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
              elevation: MaterialStatePropertyAll(5),
            ),
            onPressed: () async {
              Position position = await _determinePosition();
              location =
                  'Latitude: ${position.latitude}\n Longitude: ${position.longitude}';
              GetCity(position);
              setState(() {
                _textFormController.text = Address;
              });
            },
            child: Text(
              'Get Country Name',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "$location",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "$Address",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
