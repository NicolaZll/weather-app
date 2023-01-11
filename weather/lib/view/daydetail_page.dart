import 'package:flutter/material.dart';
import 'package:weather/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/view/function.dart';
import 'package:ionicons/ionicons.dart';

/*
DayDetailPage
Show more information about the weather of a specific hour
*/
// ignore: must_be_immutable
class DayDetailPage extends StatelessWidget {
  Daily? weatherForecasts; 
  int? dayIndex; 
  AddressData? addressData; 

  DayDetailPage({super.key, required this.weatherForecasts, this.dayIndex, required this.addressData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints){
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: [
              // Header 
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Icon(Ionicons.arrow_back_outline)),
                    Text('Previsioni ${getWeekDay(weekDayNum: DateTime.parse(weatherForecasts!.time![dayIndex!]).weekday)} - ${DateTime.parse(weatherForecasts!.time![dayIndex!]).day.toString().padLeft(2, '0')}/${DateTime.parse(weatherForecasts!.time![dayIndex!]).month.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.bold),), 
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
                                wmoCode:  weatherForecasts!.weathercode![dayIndex!],
                                sunrise: '0',
                                sunset: '0',
                              )!,
                            height: 80,
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerRight,
                            ),
                            flex: 2,
                          ),  
                          Expanded(
                            child: Text('${getWeatherConditionFromWMO(wmoCode: weatherForecasts!.weathercode![dayIndex!])}', textAlign: TextAlign.left,),
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
                                    children: [Text('Temp. min',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('${weatherForecasts!.temperature2mMin![dayIndex!].round()}°', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),)],
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
                                    children: [Text('Temp. max',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('${weatherForecasts!.temperature2mMax![dayIndex!].round()}°', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),)],
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
                                    children: [Text('Somma precipitazioni',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.precipitationSum![dayIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                                      Text(' mm', style: TextStyle(fontSize: 18),)
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
                                    children: [Text('Ore prec.',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.precipitationHours![dayIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),), 
                                      Text(' h', style: TextStyle(fontSize: 18),)
                                      ],
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
                                    children: [Text('Vento max.',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.windspeed10mMax![dayIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
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
                                      Text('${weatherForecasts!.winddirection10mDominant![dayIndex!].round()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),), 
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
                                    children: [Text('Alba',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.sunrise![dayIndex!].split('T')[1]}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                                      Text('', style: TextStyle(fontSize: 18),)
                                    ],
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
                                    children: [Text('Tramonto',  textAlign: TextAlign.center,)],
                                  ),
                                ), 
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${weatherForecasts!.sunset![dayIndex!].split('T')[1]}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),), 
                                      Text('', style: TextStyle(fontSize: 20),)
                                      ],
                                  ),
                                )  
                              ],
                            ),
                          ),
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
