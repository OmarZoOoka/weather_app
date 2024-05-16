import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:weather_ui/main.dart';
import 'package:weather_ui/models/weather_model.dart';
import 'package:weather_ui/screens/step_counter.dart';

class DataLoaded extends StatelessWidget {
  const DataLoaded({super.key, required this.weatherModel});
  final WeatherModel weatherModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            getThemeColor(weatherModel.condition),
            getThemeColor(weatherModel.condition).shade200,
            getThemeColor(weatherModel.condition),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      "Is The Weather Suitable For you ?",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StepCounter()),
                            );
                          },
                          child: Text("Yes"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Flushbar(
                              messageText: Text(
                                "Then Don't Leave The House!!!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(20),
                              borderColor: Colors.white,
                              backgroundColor: Colors.blueGrey,
                              flushbarPosition: FlushbarPosition.TOP,
                              flushbarStyle: FlushbarStyle.FLOATING,
                              duration: Duration(seconds: 3),
                            ).show(context);
                          },
                          child: Text("No"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                weatherModel.cityName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Updated at ${stringToDateTime(weatherModel.date).hour} : ${stringToDateTime(weatherModel.date).minute}",
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    "https:${weatherModel.image}",
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${weatherModel.temp.round()} C",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Column(
                    children: [
                      Text("minTemp: ${weatherModel.minTemp.round()} C"),
                      Text("maxTemp: ${weatherModel.maxTemp.round()} C"),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                weatherModel.condition,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          )
        ],
      ),
    );
  }
}

DateTime stringToDateTime(String date) {
  return DateTime.parse(date);
}
