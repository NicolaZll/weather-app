import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;

/*
Data
Used to give the data to the app 
*/
class Data{
  late WeatherData weatherForecasts; 
  late AddressData addressData; 

  Data(){}

  Data.instance({required weatherForecasts, required addressData}){
    // ignore: prefer_initializing_formals
    this.weatherForecasts = weatherForecasts; 
    // ignore: prefer_initializing_formals
    this.addressData = addressData; 
  }

  Future<Data> getCurrentPositionData() async{
    _Locator locator = _Locator(); 
    
    geolocator.Position positionData = await locator._determinePosition(); 
    return Data.instance(weatherForecasts: await _WeatherForecasts().getForecastsFromCoordinates(latitude: positionData.latitude.toString(), longitude: positionData.longitude.toString()), addressData: await _Geocoder().getLocationFromCoordinates(positionData: positionData)); 
  }

  Future<Data> getAddressData({required String address}) async{
    return Data.instance(weatherForecasts: await _WeatherForecasts().getForecastsFromAddress(address: address), addressData: AddressData(locality: address)); 
  }
}

/*
Geolocator
Get the current position of the device

Link of the used package: https://pub.dev/packages/geolocator
*/
class _Locator {
  Future<geolocator.Position> _determinePosition() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      /* Location services are not enabled don't continue
      accessing the position and request users of the
      App to enable the location services. */
      return geolocator.Position(latitude: 45.4408, longitude: 12.3155, timestamp: DateTime.now(), accuracy: 0.0, altitude: 1.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        /* Permissions are denied, next time you could try
        requesting permissions again (this is also where
        Android's shouldShowRequestPermissionRationale
        returned true. According to Android guidelines
        your App should show an explanatory UI now. */
        return geolocator.Position(latitude: 45.4408, longitude: 12.3155, timestamp: DateTime.now(), accuracy: 0.0, altitude: 1.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return geolocator.Position(latitude: 45.4408, longitude: 12.3155, timestamp: DateTime.now(), accuracy: 0.0, altitude: 1.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
    }

    /* When we reach here, permissions are granted and we can
    continue accessing the position of the device.*/
    return await geolocator.Geolocator.getCurrentPosition();
  }
}

/*
Geocoding 
Translate coordinates into location and addresses into coordinates 

Link of used package: https://pub.dev/packages/geocoding
*/
class _Geocoder {
  // Translate LocationData into an address
  Future<AddressData> getLocationFromCoordinates(
      {required geolocator.Position positionData}) async {
    List<geocoding.Placemark> address = await geocoding
        .placemarkFromCoordinates(positionData.latitude, positionData.longitude);

    return AddressData(locality: address.first.locality!);
  }

  // Translate an address into coordinates
  Future<CoordinatesData> getCoordinatesfromAddress(
      {required String address}) async {
    List<geocoding.Location> coordinates =
        await geocoding.locationFromAddress(address);

    return CoordinatesData(
        latitude: coordinates.first.latitude,
        longitude: coordinates.first.longitude);
  }
}

// Object that rapresent the Geocoder class response
class AddressData {
  String locality;

  AddressData({required this.locality});
}

class CoordinatesData {
  double latitude;
  double longitude;

  CoordinatesData({required this.latitude, required this.longitude});
}

/*
Weather Forecasts API 
The API provide information about weather forecasts

Link of the used API: https://open-meteo.com/en/docs
*/
class _WeatherForecasts {
  // Get the weather forecasts of a given address
  Future<WeatherData?> getForecastsFromAddress(
      {required String address}) async {
    CoordinatesData coordinates =
        await _Geocoder().getCoordinatesfromAddress(address: address);
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${coordinates.latitude}&longitude=${coordinates.longitude}&hourly=temperature_2m,relativehumidity_2m,dewpoint_2m,apparent_temperature,precipitation,rain,showers,snowfall,snow_depth,freezinglevel_height,weathercode,pressure_msl,surface_pressure,cloudcover,cloudcover_low,cloudcover_mid,cloudcover_high,visibility,evapotranspiration,et0_fao_evapotranspiration,vapor_pressure_deficit,cape,windspeed_10m,windspeed_80m,windspeed_120m,windspeed_180m,winddirection_10m,winddirection_80m,winddirection_120m,winddirection_180m,windgusts_10m,temperature_80m,temperature_120m,temperature_180m,soil_temperature_0cm,soil_temperature_6cm,soil_temperature_18cm,soil_temperature_54cm,soil_moisture_0_1cm,soil_moisture_1_3cm,soil_moisture_3_9cm,soil_moisture_9_27cm,soil_moisture_27_81cm&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,windspeed_10m_max,windgusts_10m_max,winddirection_10m_dominant,shortwave_radiation_sum,et0_fao_evapotranspiration&timezone=auto');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      return Future.error('Failed to load data');
    }
  }

  // Get the weather forecasts of a given location (coordinates)
  Future<WeatherData?> getForecastsFromCoordinates(
      {required String latitude, required String longitude}) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&hourly=temperature_2m,relativehumidity_2m,dewpoint_2m,apparent_temperature,precipitation,rain,showers,snowfall,snow_depth,freezinglevel_height,weathercode,pressure_msl,surface_pressure,cloudcover,cloudcover_low,cloudcover_mid,cloudcover_high,visibility,evapotranspiration,et0_fao_evapotranspiration,vapor_pressure_deficit,cape,windspeed_10m,windspeed_80m,windspeed_120m,windspeed_180m,winddirection_10m,winddirection_80m,winddirection_120m,winddirection_180m,windgusts_10m,temperature_80m,temperature_120m,temperature_180m,soil_temperature_0cm,soil_temperature_6cm,soil_temperature_18cm,soil_temperature_54cm,soil_moisture_0_1cm,soil_moisture_1_3cm,soil_moisture_3_9cm,soil_moisture_9_27cm,soil_moisture_27_81cm&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,windspeed_10m_max,windgusts_10m_max,winddirection_10m_dominant,shortwave_radiation_sum,et0_fao_evapotranspiration&timezone=auto');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      return Future.error('Failed to load data');
    }
  }
}

// Object that rappresent the data of the service api.open-meteo.com
class WeatherData {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  double? elevation;
  HourlyUnits? hourlyUnits;
  Hourly? hourly;
  DailyUnits? dailyUnits;
  Daily? daily;

  WeatherData(
      {this.latitude,
      this.longitude,
      this.generationtimeMs,
      this.utcOffsetSeconds,
      this.timezone,
      this.timezoneAbbreviation,
      this.elevation,
      this.hourlyUnits,
      this.hourly,
      this.dailyUnits,
      this.daily});

  WeatherData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = json['hourly_units'] != null
        ? new HourlyUnits.fromJson(json['hourly_units'])
        : null;
    hourly =
        json['hourly'] != null ? new Hourly.fromJson(json['hourly']) : null;
    dailyUnits = json['daily_units'] != null
        ? new DailyUnits.fromJson(json['daily_units'])
        : null;
    daily = json['daily'] != null ? new Daily.fromJson(json['daily']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['generationtime_ms'] = this.generationtimeMs;
    data['utc_offset_seconds'] = this.utcOffsetSeconds;
    data['timezone'] = this.timezone;
    data['timezone_abbreviation'] = this.timezoneAbbreviation;
    data['elevation'] = this.elevation;
    if (this.hourlyUnits != null) {
      data['hourly_units'] = this.hourlyUnits!.toJson();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly!.toJson();
    }
    if (this.dailyUnits != null) {
      data['daily_units'] = this.dailyUnits!.toJson();
    }
    if (this.daily != null) {
      data['daily'] = this.daily!.toJson();
    }
    return data;
  }
}

class HourlyUnits {
  String? time;
  String? temperature2m;
  String? relativehumidity2m;
  String? dewpoint2m;
  String? apparentTemperature;
  String? precipitation;
  String? rain;
  String? showers;
  String? snowfall;
  String? snowDepth;
  String? freezinglevelHeight;
  String? weathercode;
  String? pressureMsl;
  String? surfacePressure;
  String? cloudcover;
  String? cloudcoverLow;
  String? cloudcoverMid;
  String? cloudcoverHigh;
  String? visibility;
  String? evapotranspiration;
  String? et0FaoEvapotranspiration;
  String? vaporPressureDeficit;
  String? cape;
  String? windspeed10m;
  String? windspeed80m;
  String? windspeed120m;
  String? windspeed180m;
  String? winddirection10m;
  String? winddirection80m;
  String? winddirection120m;
  String? winddirection180m;
  String? windgusts10m;
  String? temperature80m;
  String? temperature120m;
  String? temperature180m;
  String? soilTemperature0cm;
  String? soilTemperature6cm;
  String? soilTemperature18cm;
  String? soilTemperature54cm;
  String? soilMoisture01cm;
  String? soilMoisture13cm;
  String? soilMoisture39cm;
  String? soilMoisture927cm;
  String? soilMoisture2781cm;

  HourlyUnits(
      {this.time,
      this.temperature2m,
      this.relativehumidity2m,
      this.dewpoint2m,
      this.apparentTemperature,
      this.precipitation,
      this.rain,
      this.showers,
      this.snowfall,
      this.snowDepth,
      this.freezinglevelHeight,
      this.weathercode,
      this.pressureMsl,
      this.surfacePressure,
      this.cloudcover,
      this.cloudcoverLow,
      this.cloudcoverMid,
      this.cloudcoverHigh,
      this.visibility,
      this.evapotranspiration,
      this.et0FaoEvapotranspiration,
      this.vaporPressureDeficit,
      this.cape,
      this.windspeed10m,
      this.windspeed80m,
      this.windspeed120m,
      this.windspeed180m,
      this.winddirection10m,
      this.winddirection80m,
      this.winddirection120m,
      this.winddirection180m,
      this.windgusts10m,
      this.temperature80m,
      this.temperature120m,
      this.temperature180m,
      this.soilTemperature0cm,
      this.soilTemperature6cm,
      this.soilTemperature18cm,
      this.soilTemperature54cm,
      this.soilMoisture01cm,
      this.soilMoisture13cm,
      this.soilMoisture39cm,
      this.soilMoisture927cm,
      this.soilMoisture2781cm});

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature2m = json['temperature_2m'];
    relativehumidity2m = json['relativehumidity_2m'];
    dewpoint2m = json['dewpoint_2m'];
    apparentTemperature = json['apparent_temperature'];
    precipitation = json['precipitation'];
    rain = json['rain'];
    showers = json['showers'];
    snowfall = json['snowfall'];
    snowDepth = json['snow_depth'];
    freezinglevelHeight = json['freezinglevel_height'];
    weathercode = json['weathercode'];
    pressureMsl = json['pressure_msl'];
    surfacePressure = json['surface_pressure'];
    cloudcover = json['cloudcover'];
    cloudcoverLow = json['cloudcover_low'];
    cloudcoverMid = json['cloudcover_mid'];
    cloudcoverHigh = json['cloudcover_high'];
    visibility = json['visibility'];
    evapotranspiration = json['evapotranspiration'];
    et0FaoEvapotranspiration = json['et0_fao_evapotranspiration'];
    vaporPressureDeficit = json['vapor_pressure_deficit'];
    cape = json['cape'];
    windspeed10m = json['windspeed_10m'];
    windspeed80m = json['windspeed_80m'];
    windspeed120m = json['windspeed_120m'];
    windspeed180m = json['windspeed_180m'];
    winddirection10m = json['winddirection_10m'];
    winddirection80m = json['winddirection_80m'];
    winddirection120m = json['winddirection_120m'];
    winddirection180m = json['winddirection_180m'];
    windgusts10m = json['windgusts_10m'];
    temperature80m = json['temperature_80m'];
    temperature120m = json['temperature_120m'];
    temperature180m = json['temperature_180m'];
    soilTemperature0cm = json['soil_temperature_0cm'];
    soilTemperature6cm = json['soil_temperature_6cm'];
    soilTemperature18cm = json['soil_temperature_18cm'];
    soilTemperature54cm = json['soil_temperature_54cm'];
    soilMoisture01cm = json['soil_moisture_0_1cm'];
    soilMoisture13cm = json['soil_moisture_1_3cm'];
    soilMoisture39cm = json['soil_moisture_3_9cm'];
    soilMoisture927cm = json['soil_moisture_9_27cm'];
    soilMoisture2781cm = json['soil_moisture_27_81cm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature_2m'] = this.temperature2m;
    data['relativehumidity_2m'] = this.relativehumidity2m;
    data['dewpoint_2m'] = this.dewpoint2m;
    data['apparent_temperature'] = this.apparentTemperature;
    data['precipitation'] = this.precipitation;
    data['rain'] = this.rain;
    data['showers'] = this.showers;
    data['snowfall'] = this.snowfall;
    data['snow_depth'] = this.snowDepth;
    data['freezinglevel_height'] = this.freezinglevelHeight;
    data['weathercode'] = this.weathercode;
    data['pressure_msl'] = this.pressureMsl;
    data['surface_pressure'] = this.surfacePressure;
    data['cloudcover'] = this.cloudcover;
    data['cloudcover_low'] = this.cloudcoverLow;
    data['cloudcover_mid'] = this.cloudcoverMid;
    data['cloudcover_high'] = this.cloudcoverHigh;
    data['visibility'] = this.visibility;
    data['evapotranspiration'] = this.evapotranspiration;
    data['et0_fao_evapotranspiration'] = this.et0FaoEvapotranspiration;
    data['vapor_pressure_deficit'] = this.vaporPressureDeficit;
    data['cape'] = this.cape;
    data['windspeed_10m'] = this.windspeed10m;
    data['windspeed_80m'] = this.windspeed80m;
    data['windspeed_120m'] = this.windspeed120m;
    data['windspeed_180m'] = this.windspeed180m;
    data['winddirection_10m'] = this.winddirection10m;
    data['winddirection_80m'] = this.winddirection80m;
    data['winddirection_120m'] = this.winddirection120m;
    data['winddirection_180m'] = this.winddirection180m;
    data['windgusts_10m'] = this.windgusts10m;
    data['temperature_80m'] = this.temperature80m;
    data['temperature_120m'] = this.temperature120m;
    data['temperature_180m'] = this.temperature180m;
    data['soil_temperature_0cm'] = this.soilTemperature0cm;
    data['soil_temperature_6cm'] = this.soilTemperature6cm;
    data['soil_temperature_18cm'] = this.soilTemperature18cm;
    data['soil_temperature_54cm'] = this.soilTemperature54cm;
    data['soil_moisture_0_1cm'] = this.soilMoisture01cm;
    data['soil_moisture_1_3cm'] = this.soilMoisture13cm;
    data['soil_moisture_3_9cm'] = this.soilMoisture39cm;
    data['soil_moisture_9_27cm'] = this.soilMoisture927cm;
    data['soil_moisture_27_81cm'] = this.soilMoisture2781cm;
    return data;
  }
}

class Hourly {
  List<String>? time;
  List<double>? temperature2m;
  List<int>? relativehumidity2m;
  List<double>? dewpoint2m;
  List<double>? apparentTemperature;
  List<double>? precipitation;
  List<int>? rain;
  List<int>? showers;
  List<int>? snowfall;
  List<int>? snowDepth;
  List<int>? freezinglevelHeight;
  List<int>? weathercode;
  List<double>? pressureMsl;
  List<double>? surfacePressure;
  List<int>? cloudcover;
  List<int>? cloudcoverLow;
  List<int>? cloudcoverMid;
  List<int>? cloudcoverHigh;
  List<double>? visibility;
  List<int>? evapotranspiration;
  List<int>? et0FaoEvapotranspiration;
  List<double>? vaporPressureDeficit;
  List<int>? cape;
  List<double>? windspeed10m;
  List<double>? windspeed80m;
  List<double>? windspeed120m;
  List<double>? windspeed180m;
  List<int>? winddirection10m;
  List<int>? winddirection80m;
  List<int>? winddirection120m;
  List<int>? winddirection180m;
  List<double>? windgusts10m;
  List<double>? temperature80m;
  List<double>? temperature120m;
  List<double>? temperature180m;
  List<double>? soilTemperature0cm;
  List<double>? soilTemperature6cm;
  List<double>? soilTemperature18cm;
  List<double>? soilTemperature54cm;
  List<double>? soilMoisture01cm;
  List<double>? soilMoisture13cm;
  List<double>? soilMoisture39cm;
  List<double>? soilMoisture927cm;
  List<double>? soilMoisture2781cm;

  Hourly(
      {this.time,
      this.temperature2m,
      this.relativehumidity2m,
      this.dewpoint2m,
      this.apparentTemperature,
      this.precipitation,
      this.rain,
      this.showers,
      this.snowfall,
      this.snowDepth,
      this.freezinglevelHeight,
      this.weathercode,
      this.pressureMsl,
      this.surfacePressure,
      this.cloudcover,
      this.cloudcoverLow,
      this.cloudcoverMid,
      this.cloudcoverHigh,
      this.visibility,
      this.evapotranspiration,
      this.et0FaoEvapotranspiration,
      this.vaporPressureDeficit,
      this.cape,
      this.windspeed10m,
      this.windspeed80m,
      this.windspeed120m,
      this.windspeed180m,
      this.winddirection10m,
      this.winddirection80m,
      this.winddirection120m,
      this.winddirection180m,
      this.windgusts10m,
      this.temperature80m,
      this.temperature120m,
      this.temperature180m,
      this.soilTemperature0cm,
      this.soilTemperature6cm,
      this.soilTemperature18cm,
      this.soilTemperature54cm,
      this.soilMoisture01cm,
      this.soilMoisture13cm,
      this.soilMoisture39cm,
      this.soilMoisture927cm,
      this.soilMoisture2781cm});

  Hourly.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    temperature2m = json['temperature_2m'].cast<double>();
    relativehumidity2m = json['relativehumidity_2m'].cast<int>();
    dewpoint2m = json['dewpoint_2m'].cast<double>();
    apparentTemperature = json['apparent_temperature'].cast<double>();
    precipitation = json['precipitation'].cast<double>();
    rain = json['rain'].cast<int>();
    showers = json['showers'].cast<int>();
    snowfall = json['snowfall'].cast<int>();
    snowDepth = json['snow_depth'].cast<int>();
    freezinglevelHeight = json['freezinglevel_height'].cast<int>();
    weathercode = json['weathercode'].cast<int>();
    pressureMsl = json['pressure_msl'].cast<double>();
    surfacePressure = json['surface_pressure'].cast<double>();
    cloudcover = json['cloudcover'].cast<int>();
    cloudcoverLow = json['cloudcover_low'].cast<int>();
    cloudcoverMid = json['cloudcover_mid'].cast<int>();
    cloudcoverHigh = json['cloudcover_high'].cast<int>();
    visibility = json['visibility'].cast<double>();
    evapotranspiration = json['evapotranspiration'].cast<int>();
    et0FaoEvapotranspiration = json['et0_fao_evapotranspiration'].cast<int>();
    vaporPressureDeficit = json['vapor_pressure_deficit'].cast<double>();
    cape = json['cape'].cast<int>();
    windspeed10m = json['windspeed_10m'].cast<double>();
    windspeed80m = json['windspeed_80m'].cast<double>();
    windspeed120m = json['windspeed_120m'].cast<double>();
    windspeed180m = json['windspeed_180m'].cast<double>();
    winddirection10m = json['winddirection_10m'].cast<int>();
    winddirection80m = json['winddirection_80m'].cast<int>();
    winddirection120m = json['winddirection_120m'].cast<int>();
    winddirection180m = json['winddirection_180m'].cast<int>();
    windgusts10m = json['windgusts_10m'].cast<double>();
    temperature80m = json['temperature_80m'].cast<double>();
    temperature120m = json['temperature_120m'].cast<double>();
    temperature180m = json['temperature_180m'].cast<double>();
    soilTemperature0cm = json['soil_temperature_0cm'].cast<double>();
    soilTemperature6cm = json['soil_temperature_6cm'].cast<double>();
    soilTemperature18cm = json['soil_temperature_18cm'].cast<double>();
    soilTemperature54cm = json['soil_temperature_54cm'].cast<double>();
    soilMoisture01cm = json['soil_moisture_0_1cm'].cast<double>();
    soilMoisture13cm = json['soil_moisture_1_3cm'].cast<double>();
    soilMoisture39cm = json['soil_moisture_3_9cm'].cast<double>();
    soilMoisture927cm = json['soil_moisture_9_27cm'].cast<double>();
    soilMoisture2781cm = json['soil_moisture_27_81cm'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature_2m'] = this.temperature2m;
    data['relativehumidity_2m'] = this.relativehumidity2m;
    data['dewpoint_2m'] = this.dewpoint2m;
    data['apparent_temperature'] = this.apparentTemperature;
    data['precipitation'] = this.precipitation;
    data['rain'] = this.rain;
    data['showers'] = this.showers;
    data['snowfall'] = this.snowfall;
    data['snow_depth'] = this.snowDepth;
    data['freezinglevel_height'] = this.freezinglevelHeight;
    data['weathercode'] = this.weathercode;
    data['pressure_msl'] = this.pressureMsl;
    data['surface_pressure'] = this.surfacePressure;
    data['cloudcover'] = this.cloudcover;
    data['cloudcover_low'] = this.cloudcoverLow;
    data['cloudcover_mid'] = this.cloudcoverMid;
    data['cloudcover_high'] = this.cloudcoverHigh;
    data['visibility'] = this.visibility;
    data['evapotranspiration'] = this.evapotranspiration;
    data['et0_fao_evapotranspiration'] = this.et0FaoEvapotranspiration;
    data['vapor_pressure_deficit'] = this.vaporPressureDeficit;
    data['cape'] = this.cape;
    data['windspeed_10m'] = this.windspeed10m;
    data['windspeed_80m'] = this.windspeed80m;
    data['windspeed_120m'] = this.windspeed120m;
    data['windspeed_180m'] = this.windspeed180m;
    data['winddirection_10m'] = this.winddirection10m;
    data['winddirection_80m'] = this.winddirection80m;
    data['winddirection_120m'] = this.winddirection120m;
    data['winddirection_180m'] = this.winddirection180m;
    data['windgusts_10m'] = this.windgusts10m;
    data['temperature_80m'] = this.temperature80m;
    data['temperature_120m'] = this.temperature120m;
    data['temperature_180m'] = this.temperature180m;
    data['soil_temperature_0cm'] = this.soilTemperature0cm;
    data['soil_temperature_6cm'] = this.soilTemperature6cm;
    data['soil_temperature_18cm'] = this.soilTemperature18cm;
    data['soil_temperature_54cm'] = this.soilTemperature54cm;
    data['soil_moisture_0_1cm'] = this.soilMoisture01cm;
    data['soil_moisture_1_3cm'] = this.soilMoisture13cm;
    data['soil_moisture_3_9cm'] = this.soilMoisture39cm;
    data['soil_moisture_9_27cm'] = this.soilMoisture927cm;
    data['soil_moisture_27_81cm'] = this.soilMoisture2781cm;
    return data;
  }
}

class DailyUnits {
  String? time;
  String? weathercode;
  String? temperature2mMax;
  String? temperature2mMin;
  String? apparentTemperatureMax;
  String? apparentTemperatureMin;
  String? sunrise;
  String? sunset;
  String? precipitationSum;
  String? rainSum;
  String? showersSum;
  String? snowfallSum;
  String? precipitationHours;
  String? windspeed10mMax;
  String? windgusts10mMax;
  String? winddirection10mDominant;
  String? shortwaveRadiationSum;
  String? et0FaoEvapotranspiration;

  DailyUnits(
      {this.time,
      this.weathercode,
      this.temperature2mMax,
      this.temperature2mMin,
      this.apparentTemperatureMax,
      this.apparentTemperatureMin,
      this.sunrise,
      this.sunset,
      this.precipitationSum,
      this.rainSum,
      this.showersSum,
      this.snowfallSum,
      this.precipitationHours,
      this.windspeed10mMax,
      this.windgusts10mMax,
      this.winddirection10mDominant,
      this.shortwaveRadiationSum,
      this.et0FaoEvapotranspiration});

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    weathercode = json['weathercode'];
    temperature2mMax = json['temperature_2m_max'];
    temperature2mMin = json['temperature_2m_min'];
    apparentTemperatureMax = json['apparent_temperature_max'];
    apparentTemperatureMin = json['apparent_temperature_min'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    precipitationSum = json['precipitation_sum'];
    rainSum = json['rain_sum'];
    showersSum = json['showers_sum'];
    snowfallSum = json['snowfall_sum'];
    precipitationHours = json['precipitation_hours'];
    windspeed10mMax = json['windspeed_10m_max'];
    windgusts10mMax = json['windgusts_10m_max'];
    winddirection10mDominant = json['winddirection_10m_dominant'];
    shortwaveRadiationSum = json['shortwave_radiation_sum'];
    et0FaoEvapotranspiration = json['et0_fao_evapotranspiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['weathercode'] = this.weathercode;
    data['temperature_2m_max'] = this.temperature2mMax;
    data['temperature_2m_min'] = this.temperature2mMin;
    data['apparent_temperature_max'] = this.apparentTemperatureMax;
    data['apparent_temperature_min'] = this.apparentTemperatureMin;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['precipitation_sum'] = this.precipitationSum;
    data['rain_sum'] = this.rainSum;
    data['showers_sum'] = this.showersSum;
    data['snowfall_sum'] = this.snowfallSum;
    data['precipitation_hours'] = this.precipitationHours;
    data['windspeed_10m_max'] = this.windspeed10mMax;
    data['windgusts_10m_max'] = this.windgusts10mMax;
    data['winddirection_10m_dominant'] = this.winddirection10mDominant;
    data['shortwave_radiation_sum'] = this.shortwaveRadiationSum;
    data['et0_fao_evapotranspiration'] = this.et0FaoEvapotranspiration;
    return data;
  }
}

class Daily {
  List<String>? time;
  List<int>? weathercode;
  List<double>? temperature2mMax;
  List<double>? temperature2mMin;
  List<double>? apparentTemperatureMax;
  List<double>? apparentTemperatureMin;
  List<String>? sunrise;
  List<String>? sunset;
  List<double>? precipitationSum;
  List<double>? rainSum;
  List<double>? showersSum;
  List<double>? snowfallSum;
  List<double>? precipitationHours;
  List<double>? windspeed10mMax;
  List<double>? windgusts10mMax;
  List<int>? winddirection10mDominant;
  List<double>? shortwaveRadiationSum;
  List<double>? et0FaoEvapotranspiration;

  Daily(
      {this.time,
      this.weathercode,
      this.temperature2mMax,
      this.temperature2mMin,
      this.apparentTemperatureMax,
      this.apparentTemperatureMin,
      this.sunrise,
      this.sunset,
      this.precipitationSum,
      this.rainSum,
      this.showersSum,
      this.snowfallSum,
      this.precipitationHours,
      this.windspeed10mMax,
      this.windgusts10mMax,
      this.winddirection10mDominant,
      this.shortwaveRadiationSum,
      this.et0FaoEvapotranspiration});

  Daily.fromJson(Map<String, dynamic> json) {
    time = json['time'].cast<String>();
    weathercode = json['weathercode'].cast<int>();
    temperature2mMax = json['temperature_2m_max'].cast<double>();
    temperature2mMin = json['temperature_2m_min'].cast<double>();
    apparentTemperatureMax = json['apparent_temperature_max'].cast<double>();
    apparentTemperatureMin = json['apparent_temperature_min'].cast<double>();
    sunrise = json['sunrise'].cast<String>();
    sunset = json['sunset'].cast<String>();
    precipitationSum = json['precipitation_sum'].cast<double>();
    rainSum = json['rain_sum'].cast<double>();
    showersSum = json['showers_sum'].cast<double>();
    snowfallSum = json['snowfall_sum'].cast<double>();
    precipitationHours = json['precipitation_hours'].cast<double>();
    windspeed10mMax = json['windspeed_10m_max'].cast<double>();
    windgusts10mMax = json['windgusts_10m_max'].cast<double>();
    winddirection10mDominant = json['winddirection_10m_dominant'].cast<int>();
    shortwaveRadiationSum = json['shortwave_radiation_sum'].cast<double>();
    et0FaoEvapotranspiration =
        json['et0_fao_evapotranspiration'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['weathercode'] = this.weathercode;
    data['temperature_2m_max'] = this.temperature2mMax;
    data['temperature_2m_min'] = this.temperature2mMin;
    data['apparent_temperature_max'] = this.apparentTemperatureMax;
    data['apparent_temperature_min'] = this.apparentTemperatureMin;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['precipitation_sum'] = this.precipitationSum;
    data['rain_sum'] = this.rainSum;
    data['showers_sum'] = this.showersSum;
    data['snowfall_sum'] = this.snowfallSum;
    data['precipitation_hours'] = this.precipitationHours;
    data['windspeed_10m_max'] = this.windspeed10mMax;
    data['windgusts_10m_max'] = this.windgusts10mMax;
    data['winddirection_10m_dominant'] = this.winddirection10mDominant;
    data['shortwave_radiation_sum'] = this.shortwaveRadiationSum;
    data['et0_fao_evapotranspiration'] = this.et0FaoEvapotranspiration;
    return data;
  }
}
