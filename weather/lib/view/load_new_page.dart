import 'package:flutter/material.dart'; 
import 'package:weather/model.dart';
import 'package:weather/view/weatherforecasts_page.dart';

// ignore: must_be_immutable
class LoadNewWeatherForecastsPage extends StatelessWidget {
  String? address; 
  LoadNewWeatherForecastsPage({super.key, required address}){
    this.address = address; 
  }

  @override
  Widget build(BuildContext context) {
    if(address == 'currentLocation'){
      return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: Data().getCurrentPositionData(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return WeatherForecastsPage(weatherForecasts: snapshot.data!.weatherForecasts, location: snapshot.data!.addressData); 
              }
              else if(snapshot.hasError){
                return const Center(child: Text('Errore nel caricamento'),); 
              }
              else{
                return const Center(child: CircularProgressIndicator(),); 
              }
            },
          ),
        ), 
      );
    }
    else{
      return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: Data().getAddressData(address: address!),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return WeatherForecastsPage(weatherForecasts: snapshot.data!.weatherForecasts, location: snapshot.data!.addressData); 
              }
              else if(snapshot.hasError){
                return const Center(child: Text('Errore nel caricamento'),); 
              }
              else{
                return const Center(child: CircularProgressIndicator(),); 
              }
            },
          ),
        ), 
      ); 
    }
  }
}