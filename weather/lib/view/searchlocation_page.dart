import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:weather/model.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:app_settings/app_settings.dart';
import 'package:weather/view/load_new_page.dart';
import 'package:free_place_search/core/api.dart';
import 'package:free_place_search/models/address.dart';
import 'package:free_place_search/place_search.dart';

// ignore: must_be_immutable
class SearchLocationPage extends StatefulWidget {
  AddressData? location;
  SearchLocationPage({super.key, required this.location});

  @override
  State<SearchLocationPage> createState() =>
      _SearchLocationPageState(location: this.location);
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  AddressData? location;
  _SearchLocationPageState({required this.location});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Icon(Ionicons.arrow_back_outline)),
                    Text(
                      'Cerca località',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).highlightColor.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: FutureBuilder(
                                future: Data().getCurrentPositionData(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return Text('Posizione attuale (${snapshot.data!.addressData.locality})'); 
                                  }
                                  else{
                                    return const Text('Posizione attuale'); 
                                  }
                                },
                              ),
                              ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 15, left: 25, right: 25),
                            child: Row(children: [
                              Flexible(
                                child: Text(
                                  'La tua posizione viene rilevata tramite localizzazione GPS',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    child: Text('Non localizzarmi'),
                                    onPressed: (() =>
                                        Dialogs.bottomMaterialDialog(
                                            title: 'Gestisci autorizzazioni',
                                            msg:
                                                "Sei sicuro di voler revocare le tue autorizzazioni a localizzarti? \n(Le modifiche diverranno effettive dalla prossima apertura dell'app)",
                                            context: context,
                                            actions: [
                                              IconsOutlineButton(
                                                onPressed: () => AppSettings
                                                    .openAppSettings(),
                                                text: 'Revoca',
                                              ),
                                              IconsOutlineButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                text: 'Non revocare',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                textStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                                iconColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              )
                                            ])),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    child: Text('Visualizza meteo'),
                                    onPressed: (() {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return LoadNewWeatherForecastsPage(
                                          address: 'currentLocation',
                                        );
                                      }), (r) {
                                        return false;
                                      });
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ), 
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(1),
                              ),
                              width: constraints.maxWidth * 0.85,
                              child: Center(
                                child: TextButton(
                                  child: Text(
                                    "Cerca un'altra località",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                  onPressed: () {
                                    PlaceAutocomplete.show(
                                        autoFocus: true,
                                        context: context,
                                        onDone: (place) {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return LoadNewWeatherForecastsPage(
                                              address: place.address!.name,
                                            );
                                          }), (r) {
                                            return false;
                                          });
                                        });
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
