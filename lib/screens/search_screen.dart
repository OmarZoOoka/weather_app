import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_ui/cubit/get_weather_cubit.dart';
import 'package:weather_ui/cubit/weather_state_cubit.dart';
import 'package:weather_ui/screens/data_is_loaded.dart';
import 'package:weather_ui/screens/no_body_search.dart';
import 'package:weather_ui/screens/search_city.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchCity(),
                  ));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          
        ],
      ),
      body: BlocBuilder<GetWeatherCubit, WeatherStates>(
        builder: (context, state) {
          if (state is InitialState) {
            return const NoDataLoaded();
          } else if (state is WeatherSucessState) {
            return DataLoaded(
              weatherModel: state.weatherModel,
            );
          } else {
            return const Center(child: Text("oops, there was an error"));
          }
        },
      ),
    );
  }
}
