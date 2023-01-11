/*
Method to get the weekday
*/
String? getWeekDay({required int weekDayNum}) {
  String? weekday;
  switch (weekDayNum) {
    case 1:
      weekday = 'Lunedì';
      break;
    case 2:
      weekday = 'Martedì';
      break;
    case 3:
      weekday = 'Mercoledì';
      break;
    case 4:
      weekday = 'Giovedì';
      break;
    case 5:
      weekday = 'Venerdì';
      break;
    case 6:
      weekday = 'Sabato';
      break;
    case 7:
      weekday = 'Domenica';
      break;
  }
  return weekday;
}

/*
Method to get the weather condition from WMO codes (see https://open-meteo.com/en/docs for more information)

TO GET WeatherCondition (EXAMPLE): ${getWeatherConditionFromWMO(wmoCode: weatherForecasts!.hourly!.weathercode![DateTime.now().hour])![0].toUpperCase()}${getWeatherConditionFromWMO(wmoCode: weatherForecasts!.hourly!.weathercode![DateTime.now().hour])!.substring(1)}

TO GET Svg (EXAMPLE): 
SvgPicture.asset(
  getSvgFromWMO(
      wmoCode: weatherForecasts!
          .hourly!.weathercode![DateTime.now().hour],
      sunrise: weatherForecasts!.daily!.sunrise![0],
      sunset: weatherForecasts!.daily!.sunset![0])!,
  height: 150,
  fit: BoxFit.fitHeight,
),
*/
String? getWeatherConditionFromWMO({required int wmoCode}) {
  String? weatherCondition;
  switch (wmoCode) {
    case 0:
      weatherCondition = 'Cielo sereno';
      break;
    case 1:
      weatherCondition = 'Prevalentemente sereno';
      break;
    case 2:
      weatherCondition = 'Parzialmente nuvoloso';
      break;
    case 3:
      weatherCondition = 'Nuvoloso';
      break;
    case 45:
      weatherCondition = 'Nebbia';
      break;
    case 48:
      weatherCondition = 'Deposito brina';
      break;
    case 51:
      weatherCondition = 'Pioggerellina leggera';
      break;
    case 53:
      weatherCondition = 'Pioggerellina moderata';
      break;
    case 55:
      weatherCondition = 'Pioggerellina abbondante';
      break;
    case 56:
      weatherCondition = 'Pioggerellina gelata leggera';
      break;
    case 57:
      weatherCondition = 'Pioggerellina gelata abbondante';
      break;
    case 61:
      weatherCondition = 'Pioggia leggera';
      break;
    case 63:
      weatherCondition = 'Pioggia moderata';
      break;
    case 65:
      weatherCondition = 'Pioggia abbondante';
      break;
    case 66:
      weatherCondition = 'Pioggia gelata leggera';
      break;
    case 67:
      weatherCondition = 'Pioggia gelata abbondante';
      break;
    case 71:
      weatherCondition = 'Neve leggera';
      break;
    case 73:
      weatherCondition = 'Neve moderata';
      break;
    case 75:
      weatherCondition = 'Neve abbondante';
      break;
    case 77:
      weatherCondition = 'Grandine';
      break;
    case 80:
      weatherCondition = 'Rovesci di pioggia leggeri';
      break;
    case 81:
      weatherCondition = 'Rovesci di pioggia moderati';
      break;
    case 82:
      weatherCondition = 'Rovesci di pioggia abbondanti';
      break;
    case 85:
      weatherCondition = 'Rovesci di neve leggeri';
      break;
    case 86:
      weatherCondition = 'Rovesci di neve abbondanti';
      break;
    case 95:
      weatherCondition = 'Temporale';
      break;
    case 96:
      weatherCondition = 'Temporale con grandine leggera';
      break;
    case 99:
      weatherCondition = 'Temporale con grandine abbondante';
      break;
    default:
      break;
  }
  return weatherCondition;
}

String? getSvgFromWMO(
    {required int wmoCode,
    String sunrise = '0',
    String sunset = '0',
    int? time = null}) {
  bool isNight = false;
  if (sunrise != '0' && sunset != '0' && time == null) {
    if ((DateTime.now().hour < int.parse(sunrise.split('T')[1].split(':')[0]) &&
            DateTime.now().minute <
                int.parse(sunrise.split('T')[1].split(':')[1])) ||
        (DateTime.now().hour < int.parse(sunrise.split('T')[1].split(':')[0]) &&
            DateTime.now().minute >
                int.parse(sunrise.split('T')[1].split(':')[1])) ||
        (DateTime.now().hour ==
                int.parse(sunrise.split('T')[1].split(':')[0]) &&
            DateTime.now().minute <
                int.parse(sunrise.split('T')[1].split(':')[1])) ||
        (DateTime.now().hour > int.parse(sunset.split('T')[1].split(':')[0]) &&
            DateTime.now().minute >
                int.parse(sunset.split('T')[1].split(':')[1])) ||
        (DateTime.now().hour > int.parse(sunset.split('T')[1].split(':')[0]) &&
            DateTime.now().minute <
                int.parse(sunset.split('T')[1].split(':')[1])) ||
        (DateTime.now().hour == int.parse(sunset.split('T')[1].split(':')[0]) &&
            DateTime.now().minute >
                int.parse(sunset.split('T')[1].split(':')[1]))) {
      isNight = true;
    }
  } else if (sunrise != '0' && sunset != '0' && time != null) {
    if ((time < int.parse(sunrise.split('T')[1].split(':')[0])) ||
        (time < int.parse(sunrise.split('T')[1].split(':')[0])) ||
        (time == int.parse(sunrise.split('T')[1].split(':')[0])) ||
        (time > int.parse(sunset.split('T')[1].split(':')[0])) ||
        (time > int.parse(sunset.split('T')[1].split(':')[0])) ||
        (time == int.parse(sunset.split('T')[1].split(':')[0]))) {
      isNight = true;
    }
  }

  String? path = 'assets/icons/';
  if (!isNight) {
    switch (wmoCode) {
      case 0:
        path += 'day.svg';
        break;
      case 1:
        path += 'cloudy-day-1.svg';
        break;
      case 2:
        path += 'cloudy-day-2.svg';
        break;
      case 3:
        path += 'cloudy.svg';
        break;
      case 45:
        path += 'cloudy-day-3.svg';
        break;
      case 48:
        path += 'cloudy-day-3.svg';
        break;
      case 51:
        path += 'rainy-1.svg';
        break;
      case 53:
        path += 'rainy-2.svg';
        break;
      case 55:
        path += 'rainy-3.svg';
        break;
      case 56:
        path += 'snowy-2.svg';
        break;
      case 57:
        path += 'snowy-3.svg';
        break;
      case 61:
        path += 'rainy-4.svg';
        break;
      case 63:
        path += 'rainy-5.svg';
        break;
      case 65:
        path += 'rainy-6.svg';
        break;
      case 66:
        path += 'snowy-4.svg';
        break;
      case 67:
        path += 'snowy-4.svg';
        break;
      case 71:
        path += 'snowy-4.svg';
        break;
      case 73:
        path += 'snowy-5.svg';
        break;
      case 75:
        path += 'snowy-6.svg';
        break;
      case 77:
        path += 'rainy-7.svg';
        break;
      case 80:
        path += 'rainy-6.svg';
        break;
      case 81:
        path += 'rainy-6.svg';
        break;
      case 82:
        path += 'rainy-6.svg';
        break;
      case 85:
        path += 'snowy-6.svg';
        break;
      case 86:
        path += 'snowy-6.svg';
        break;
      case 95:
        path += 'thunder.svg';
        break;
      case 96:
        path += 'thunder.svg';
        break;
      case 99:
        path += 'thunder.svg';
        break;
      default:
        break;
    }
  } else {
    switch (wmoCode) {
      case 0:
        path += 'night.svg';
        break;
      case 1:
        path += 'cloudy-night-1.svg';
        break;
      case 2:
        path += 'cloudy-night-2.svg';
        break;
      case 3:
        path += 'cloudy.svg';
        break;
      case 45:
        path += 'cloudy-night-3.svg';
        break;
      case 48:
        path += 'cloudy-night-3.svg';
        break;
      case 51:
        path += 'rainy-1.svg';
        break;
      case 53:
        path += 'rainy-2.svg';
        break;
      case 55:
        path += 'rainy-3.svg';
        break;
      case 56:
        path += 'snowy-2.svg';
        break;
      case 57:
        path += 'snowy-3.svg';
        break;
      case 61:
        path += 'rainy-4.svg';
        break;
      case 63:
        path += 'rainy-5.svg';
        break;
      case 65:
        path += 'rainy-6.svg';
        break;
      case 66:
        path += 'snowy-4.svg';
        break;
      case 67:
        path += 'snowy-4.svg';
        break;
      case 71:
        path += 'snowy-4.svg';
        break;
      case 73:
        path += 'snowy-5.svg';
        break;
      case 75:
        path += 'snowy-6.svg';
        break;
      case 77:
        path += 'rainy-7.svg';
        break;
      case 80:
        path += 'rainy-6.svg';
        break;
      case 81:
        path += 'rainy-6.svg';
        break;
      case 82:
        path += 'rainy-6.svg';
        break;
      case 85:
        path += 'snowy-6.svg';
        break;
      case 86:
        path += 'snowy-6.svg';
        break;
      case 95:
        path += 'thunder.svg';
        break;
      case 96:
        path += 'thunder.svg';
        break;
      case 99:
        path += 'thunder.svg';
        break;
      default:
        break;
    }
  }
  return path;
}
