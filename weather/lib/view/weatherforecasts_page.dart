import 'package:flutter/material.dart';
import 'package:weather/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/view/daydetail_page.dart';
import 'package:weather/view/function.dart';
import 'package:weather/view/hourdetail_page.dart';
import 'package:weather/view/searchlocation_page.dart';

/*
WeatherForecastsPage 
This Widget display the weather of the given location 
*/
// ignore: must_be_immutable
class WeatherForecastsPage extends StatelessWidget {
  WeatherForecastsPage(
      {super.key, required weatherForecasts, required location}) {
    // ignore: prefer_initializing_formals
    this.location = location;
    // ignore: prefer_initializing_formals
    this.weatherForecasts = weatherForecasts;
  }

  AddressData? location;
  WeatherData? weatherForecasts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: [
              // Current weather
              Container(
                height: constraints.maxHeight * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${weatherForecasts!.hourly!.temperature2m![DateTime.now().hour].round()}°', style: TextStyle(fontSize: 28),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${location!.locality}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                getSvgFromWMO(
                                    wmoCode: weatherForecasts!.hourly!.weathercode![DateTime.now().hour],
                                    sunrise:weatherForecasts!.daily!.sunrise![0],
                                    sunset:weatherForecasts!.daily!.sunset![0]
                                )!,
                                height: 160,
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Weather of the next 24h
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).highlightColor.withOpacity(0.1),
                          ),
                          width: constraints.maxWidth * 0.85,
                          height: constraints.maxHeight * 0.2,
                          child: ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 24,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HourDetailPage(weatherForecasts: weatherForecasts!.hourly, hourIndex: index + DateTime.now().hour, addressData: location, dailyForecasts: weatherForecasts!.daily, dayIndex: 0,),)); 
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text('${DateTime.now().hour + index > 23 ? DateTime.now().hour + index - 24 : DateTime.now().hour + index}:00'),
                                          ),
                                        ),
                                        Expanded(
                                          child: SvgPicture.asset(
                                            getSvgFromWMO(
                                                wmoCode: weatherForecasts!.hourly!.weathercode![DateTime.now().hour + index],
                                                sunrise: weatherForecasts!.daily!.sunrise![0],
                                                sunset: weatherForecasts!.daily!.sunset![0],
                                                time: DateTime.now().hour + index > 23 ? DateTime.now().hour + index - 24 : DateTime.now().hour + index
                                            )!,
                                            height: 40,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                              child: Text('${weatherForecasts!.hourly!.temperature2m![DateTime.now().hour + index].round()}°')
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ); 
                              },
                            ),
                          ))
                    ],
                  )
                ],
              ),

              // Week forecasts
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 35),
                        decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Theme.of(context).highlightColor.withOpacity(0.1),
                                  ),
                        width: constraints.maxWidth * 0.85,
                        height: constraints.maxHeight * 0.32,
                        child: ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: ListView.builder(
                            itemCount: weatherForecasts!.daily!.weathercode!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DayDetailPage(weatherForecasts: weatherForecasts!.daily, dayIndex: index, addressData: location),)); 
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('${getWeekDay(weekDayNum: DateTime.parse(weatherForecasts!.daily!.time![index]).weekday)}')), 
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SvgPicture.asset(
                                                  getSvgFromWMO(
                                                      wmoCode: weatherForecasts!.daily!.weathercode![index],
                                                      sunrise: '0',
                                                      sunset: '0',
                                                  )!,
                                                  height: 40,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                        ) 
                                      ), 
                                      Expanded(child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('${weatherForecasts!.daily!.temperature2mMin![index].round()}°  -  ${weatherForecasts!.daily!.temperature2mMax![index].round()}°'),
                                        ), 
                                      ),  
                                    ],
                                  ),
                                ),
                              ); 
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ), 

              // Search Other locality
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Theme.of(context).primaryColor.withOpacity(1),
                                  ),
                        width: constraints.maxWidth * 0.85,
                        child: Center(
                          child: TextButton(
                            child: Text("Cerca un'altra località", style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchLocationPage(location: location,),)); 
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ));
    }));
  }
}