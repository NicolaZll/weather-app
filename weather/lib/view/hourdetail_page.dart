import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:weather/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/view/function.dart';

/*
HourDetailPage
Show more information about the weather of a specific hour
*/
// ignore: must_be_immutable
class HourDetailPage extends StatelessWidget {
  Hourly? weatherForecasts; 
  int? hourIndex; 
  Daily? dailyForecasts; 
  int? dayIndex; 
  AddressData? addressData; 

  HourDetailPage({super.key, required this.weatherForecasts, required this.hourIndex, required this.addressData, required this.dailyForecasts, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints){
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Icon(Ionicons.arrow_back_outline)),
                    Text('Previsioni ore ${weatherForecasts!.time![hourIndex!].split('T')[1]} di ${getWeekDay(weekDayNum: DateTime.parse(weatherForecasts!.time![hourIndex!].split('T')[0]).weekday)} ${ DateTime.parse(weatherForecasts!.time![hourIndex!].split('T')[0]).day}', style: TextStyle(fontWeight: FontWeight.bold),), 
                  ],
                ),
              ), 

              // Weather Forecasts 
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.all(Radius.circular(15)), 
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SvgPicture.asset(
                              getSvgFromWMO(
                                wmoCode:  weatherForecasts!.weathercode![hourIndex!],
                                sunrise: dailyForecasts!.sunrise![dayIndex!],
                                sunset: dailyForecasts!.sunset![dayIndex!],
                                time: DateTime.parse(weatherForecasts!.time![hourIndex!]).hour, 
                              )!,
                            height: 80,
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerRight,
                            ),
                            flex: 2,
                          ),  
                          Expanded(
                            child: Text('${getWeatherConditionFromWMO(wmoCode: weatherForecasts!.weathercode![hourIndex!])}', textAlign: TextAlign.left,),
                            flex: 7,
                          )
                        ],
                      ),
                    ), 

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 20, right: 10,),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)), 
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Temp. percep.',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('${weatherForecasts!.apparentTemperature![hourIndex!].round()}°', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),)],
                                  ),
                                )  
                              ],
                            ),
                          ), 
                        ), 

                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 20, left: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)), 
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Temp',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('${weatherForecasts!.temperature2m![hourIndex!].round()}°', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),)],
                                  ),
                                )  
                              ],
                            ),
                          ), 
                        ), 
                      ],
                    ), 

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 20, right: 10,),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)), 
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Precipitazioni',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.precipitation![hourIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                                      Text(' mm', style: TextStyle(fontSize: 18),)
                                    ],
                                  ),
                                )  
                              ],
                            ),
                          ), 
                          flex: 2,
                        ), 
                      ],
                    ), 

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 20, right: 10,),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)), 
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Vento',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.windspeed10m![hourIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                                      Text(' km/h', style: TextStyle(fontSize: 18),)
                                    ],
                                  ),
                                )  
                              ],
                            ),
                          ), 
                          flex: 2,
                        ), 

                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: EdgeInsets.only(bottom: 20, left: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.all(Radius.circular(15)), 
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Direzione vento',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.winddirection10m![hourIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),), 
                                      Text('°', style: TextStyle(fontSize: 20),)
                                      ],
                                  ),
                                )  
                              ],
                            ),
                          ),
                          flex: 3, 
                        ), 
                      ],
                    ), 
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}