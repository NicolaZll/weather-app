import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/model.dart';
import 'package:animations/animations.dart';
import 'package:weather/view/introduction_page.dart';
import 'package:weather/view/weatherforecasts_page.dart';

/*
The icon used for display the weather need attribution!
See more details in: https://www.amcharts.com/free-animated-svg-weather-icons/
*/
void main() => {
      /*
      App settings: 
        - Primary color (color mainly used for the interface): #0381fe
        - Font family: Poppins (from fonts.google.com)
        - Transition: default transition theme is set to SharedAxisPageTransition (horizontal), for more information view https://pub.dev/packages/animations
        - Theme mode: set to light by default (actually dark mode is not supported)
        - Home: FirsPage()
      */
      runApp(MaterialApp(
        // Primary color of the interface
        color: const Color(0xFF0381fe),

        // App theme
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Poppins',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
              TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
            },
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Poppins',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
              TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.horizontal,
              ),
            },
          ),
        ),
        themeMode: ThemeMode.light,

        // Home
        home: const FirstPage(),

        // Option
        debugShowCheckedModeBanner: false,
      ))
    };

/*
First Page 

The Widget contain an AnnotatedRegion in order to change the color of the status bar and the navigation bar

This Widget is used for display the correct widget after some check: 
  - If is the first time that the user launch the app:
    - set the value 'firstTime' (saved with shared_preferences package) to false 
    - display IntroductionPage()
  - Else:return WeatherForecast of the currentLocation
*/

// IMPROVE THE LOADING OF THE DATA!!!!
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarDividerColor:
            Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),

      //SafeArea
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            // Obtain shared preferences
            future: SharedPreferences.getInstance(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.getBool('firstTime') == false) {
                  return FutureBuilder(
                    future: Data().getCurrentPositionData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return WeatherForecastsPage(
                            weatherForecasts: snapshot.data!.weatherForecasts,
                            location: snapshot.data!.addressData);
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Errore nel caricamento'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                } else {
                  snapshot.data!.setBool('firstTime', false);
                  return const IntroductionPage();
                }
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Errore nel caricamento'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
