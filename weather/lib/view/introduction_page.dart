import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:weather/main.dart';

/*
IntroductionPage
The introduction page is displayed only during the first launch of the app and give several information about the app to the user 
This Widget use 'introduction_screen' package, link of the package: https://pub.dev/packages/introduction_screen
*/
class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final buttonStyle = const TextStyle(fontSize: 14);
  final pageDecoration = const PageDecoration(
    imagePadding: EdgeInsets.only(),
    bodyPadding: EdgeInsets.only(left: 40, right: 40),
    titlePadding: EdgeInsets.only(left: 40, right: 40, top: 25, bottom: 5),
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  );

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showDoneButton: true,
      showNextButton: true,
      showBackButton: false,
      showSkipButton: true,
      done: Text(
        'Inizia',
        style: buttonStyle,
      ),
      next: Text(
        'Prossimo',
        style: buttonStyle,
      ),
      skip: Text(
        'Salta',
        style: buttonStyle,
      ),
      onDone: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return FirstPage();
        }), (r){
          return false;
        });
      },
      onSkip: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return FirstPage();
        }), (r){
          return false;
        });
      },
      pages: [
        PageViewModel(
          decoration: pageDecoration,
          title: "Benvenuto!",
          body:
              "Ottieni le informazioni meteo di oggi e dei prossimi giorni in modo semplice e veloce!",
          image: Image.asset('assets/images/undraw_weather.png'),
        ),
        PageViewModel(
          decoration: pageDecoration,
          title: "La tua posizione",
          body:
              "Tra poco ti verrà chiesto di fornirci l'autorizzazione per accedere alla tua posizione. Consentici di accedervi per un corretto funzionamento dell'app!",
          image: Image.asset('assets/images/undraw_pointer.png'),
        )
      ],
    );
  }
}