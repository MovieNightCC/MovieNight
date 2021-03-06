import 'package:flutter/material.dart';
import '../utils/helpers.dart';
import './movieArray.dart';
import './movieInfo.dart';
import './swiper.dart';

Map<String, bool> values = {
  'foo': true,
  'bar': false,
};

List<bool> isChecked;
bool clickedAll = false;
bool clickedAnime = false;
bool clickedLGBT = false;
bool clickedHorror = false;
bool clickedIndie = false;
bool clickedJapan = false;
bool clickedKorea = false;
bool clickedMartial = false;
bool clickedMusic = false;
bool clickedScifi = false;
bool clickedSuperhero = false;
bool clickedRomance = false;

List<String> chosenGenre = [];

void filterPop(context) {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return new AlertDialog(
            backgroundColor: Colors.grey[900],
            title: new Text("What do you want to watch?",
                style: TextStyle(color: Colors.pink)),
            content: Container(
              width: double.maxFinite,
              child: ListView(children: <Widget>[
                CheckboxListTile(
                  title: Text("All Movies",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedAll,
                  onChanged: (val) {
                    setState(() {
                      clickedAll = val;
                      clickedAnime = val;
                      clickedLGBT = val;
                      clickedHorror = val;
                      clickedRomance = val;
                      clickedJapan = val;
                      clickedKorea = val;
                      clickedMartial = val;
                      clickedMusic = val;
                      clickedScifi = val;
                      clickedSuperhero = val;
                      if (clickedAnime && !chosenGenre.contains('Anime')) {
                        chosenGenre.add('Anime');
                      }
                      if (!clickedAnime) {
                        chosenGenre.remove('Anime');
                      }

                      if (clickedSuperhero &&
                          !chosenGenre.contains('Superheroes Movies')) {
                        chosenGenre.add('Superheroes Movies');
                      }
                      if (!clickedSuperhero) {
                        chosenGenre.remove('Superheroes Movies');
                      }

                      if (clickedScifi &&
                          !chosenGenre.contains('Sci-fi Movies')) {
                        chosenGenre.add('Sci-fi Movies');
                      }
                      if (!clickedScifi) {
                        chosenGenre.remove('Sci-fi Movies');
                      }

                      if (clickedMusic &&
                          !chosenGenre.contains('Music-related Movies')) {
                        chosenGenre.add('Music-related Movies');
                      }
                      if (!clickedMusic) {
                        chosenGenre.remove('Music-related Movies');
                      }

                      if (clickedMartial &&
                          !chosenGenre.contains('Martial Arts Movies')) {
                        chosenGenre.add('Martial Arts Movies');
                      }
                      if (!clickedMartial) {
                        chosenGenre.remove('Martial Arts Movies');
                      }

                      if (clickedKorea &&
                          !chosenGenre.contains('Korean Movies')) {
                        chosenGenre.add('Korean Movies');
                      }
                      if (!clickedKorea) {
                        chosenGenre.remove('Korean Movies');
                      }

                      if (clickedJapan &&
                          !chosenGenre.contains('Japanese Movies')) {
                        chosenGenre.add('Japanese Movies');
                      }
                      if (!clickedJapan) {
                        chosenGenre.remove('Japanese Movies');
                      }

                      if (clickedJapan &&
                          !chosenGenre.contains('Japanese Movies')) {
                        chosenGenre.add('Japanese Movies');
                      }
                      if (!clickedJapan) {
                        chosenGenre.remove('Japanese Movies');
                      }

                      if (clickedRomance && !chosenGenre.contains('Romance')) {
                        chosenGenre.add('Romance');
                      }
                      if (!clickedRomance) {
                        chosenGenre.remove('Romance');
                      }

                      if (clickedHorror &&
                          !chosenGenre.contains('Horror/Thrillers')) {
                        chosenGenre.add('Horror/Thrillers');
                      }
                      if (!clickedHorror) {
                        chosenGenre.remove('Horror/Thrillers');
                      }

                      if (clickedLGBT && !chosenGenre.contains('LGBTQ')) {
                        chosenGenre.add('LGBTQ');
                      }
                      if (!clickedLGBT) {
                        chosenGenre.remove('LGBTQ');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Anime",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedAnime,
                  onChanged: (val) {
                    setState(() {
                      clickedAnime = val;
                      if (clickedAnime && !chosenGenre.contains('Anime')) {
                        chosenGenre.add('Anime');
                      }
                      if (!clickedAnime) {
                        chosenGenre.remove('Anime');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("LGBTQ Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedLGBT,
                  onChanged: (val) {
                    setState(() {
                      clickedLGBT = val;
                      if (clickedLGBT && !chosenGenre.contains('LGBTQ')) {
                        chosenGenre.add('LGBTQ');
                      }
                      if (!clickedLGBT) {
                        chosenGenre.remove('LGBTQ');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Horror/Thrillers",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedHorror,
                  onChanged: (val) {
                    setState(() {
                      clickedHorror = val;
                      if (clickedHorror &&
                          !chosenGenre.contains('Horror/Thrillers')) {
                        chosenGenre.add('Horror/Thrillers');
                      }
                      if (!clickedHorror) {
                        chosenGenre.remove('Horror/Thrillers');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Romance",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedRomance,
                  onChanged: (val) {
                    setState(() {
                      clickedRomance = val;
                      if (clickedRomance && !chosenGenre.contains('Romance')) {
                        chosenGenre.add('Romance');
                      }
                      if (!clickedRomance) {
                        chosenGenre.remove('Romance');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Japanese Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedJapan,
                  onChanged: (val) {
                    setState(() {
                      clickedJapan = val;
                      if (clickedJapan &&
                          !chosenGenre.contains('Japanese Movies')) {
                        chosenGenre.add('Japanese Movies');
                      }
                      if (!clickedJapan) {
                        chosenGenre.remove('Japanese Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Korean Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedKorea,
                  onChanged: (val) {
                    setState(() {
                      clickedKorea = val;
                      if (clickedKorea &&
                          !chosenGenre.contains('Korean Movies')) {
                        chosenGenre.add('Korean Movies');
                      }
                      if (!clickedKorea) {
                        chosenGenre.remove('Korean Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Martial Arts Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedMartial,
                  onChanged: (val) {
                    setState(() {
                      clickedMartial = val;
                      if (clickedMartial &&
                          !chosenGenre.contains('Martial Arts Movies')) {
                        chosenGenre.add('Martial Arts Movies');
                      }
                      if (!clickedMartial) {
                        chosenGenre.remove('Martial Arts Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Music-related Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedMusic,
                  onChanged: (val) {
                    setState(() {
                      clickedMusic = val;
                      if (clickedMusic &&
                          !chosenGenre.contains('Music-related Movies')) {
                        chosenGenre.add('Music-related Movies');
                      }
                      if (!clickedMusic) {
                        chosenGenre.remove('Music-related Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Sci-fi Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedScifi,
                  onChanged: (val) {
                    setState(() {
                      clickedScifi = val;
                      if (clickedScifi &&
                          !chosenGenre.contains('Sci-fi Movies')) {
                        chosenGenre.add('Sci-fi Movies');
                      }
                      if (!clickedScifi) {
                        chosenGenre.remove('Sci-fi Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Superheroes Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  value: clickedSuperhero,
                  onChanged: (val) {
                    setState(() {
                      clickedSuperhero = val;
                      if (clickedSuperhero &&
                          !chosenGenre.contains('Superheroes Movies')) {
                        chosenGenre.add('Superheroes Movies');
                      }
                      if (!clickedSuperhero) {
                        chosenGenre.remove('Superheroes Movies');
                      }
                      print('$chosenGenre IAM GENRE ARRAY');
                    });
                  },
                )
              ]),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text("Confirm",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        height: 1.5,
                      )),
                  onPressed: () {
                    if (chosenGenre.length == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Swiper(),
                              maintainState: true));
                    }
                    // else if (clickedAll == true) {
                    //   //placeholer
                    // }
                    else {
                      movieDataTest = [];
                      movieImagesTest = [];
                      movieTitles = [];
                      moviesSynopsis = [];
                      movieYear = [];
                      movieRuntime = [];
                      movieGenre = [];
                      // List<String> chosenGenre = [];
                      if (chosenGenre.contains("Anime")) {
                        for (var i = 0; i < animeNfid.length; i++) {
                          movieDataTest.add(animeNfid[i]);
                          movieImagesTest.add(animeImages[i]);
                          movieTitles.add(animeTitles[i]);
                          movieGenre.add(animeGenre[i]);
                          moviesSynopsis.add(animeSynopsis[i]);
                          movieYear.add(animeYear[i]);
                          movieRuntime.add(animeRuntime[i]);
                        }

                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Horror/Thrillers")) {
                        for (var i = 0; i < horrorNfid.length; i++) {
                          movieDataTest.add(horrorNfid[i]);
                          movieImagesTest.add(horrorImages[i]);
                          movieTitles.add(horrorTitles[i]);
                          movieGenre.add(horrorGenre[i]);
                          moviesSynopsis.add(horrorSynopsis[i]);
                          movieYear.add(horrorYear[i]);
                          movieRuntime.add(horrorRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Japanese Movies")) {
                        for (var i = 0; i < japanNfid.length; i++) {
                          movieDataTest.add(japanNfid[i]);
                          movieImagesTest.add(japanImages[i]);
                          movieTitles.add(japanTitles[i]);
                          movieGenre.add(japanGenre[i]);
                          moviesSynopsis.add(japanSynopsis[i]);
                          movieYear.add(japanYear[i]);
                          movieRuntime.add(japanRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Korean Movies")) {
                        for (var i = 0; i < koreaNfid.length; i++) {
                          movieDataTest.add(koreaNfid[i]);
                          movieImagesTest.add(koreaImages[i]);
                          movieTitles.add(koreaTitles[i]);
                          movieGenre.add(koreaGenre[i]);
                          moviesSynopsis.add(koreaSynopsis[i]);
                          movieYear.add(koreaYear[i]);
                          movieRuntime.add(koreaRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Romance")) {
                        for (var i = 0; i < romanceNfid.length; i++) {
                          movieDataTest.add(romanceNfid[i]);
                          movieImagesTest.add(romanceImages[i]);
                          movieTitles.add(romanceTitles[i]);
                          movieGenre.add(romanceGenre[i]);
                          moviesSynopsis.add(romanceSynopsis[i]);
                          movieYear.add(romanceYear[i]);
                          movieRuntime.add(romanceRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Martial Arts Movies")) {
                        for (var i = 0; i < martialArtsNfid.length; i++) {
                          movieDataTest.add(martialArtsNfid[i]);
                          movieImagesTest.add(martialArtsImages[i]);
                          movieTitles.add(martialArtsTitles[i]);
                          movieGenre.add(martialArtsGenre[i]);
                          moviesSynopsis.add(martialArtsSynopsis[i]);
                          movieYear.add(martialArtsYear[i]);
                          movieRuntime.add(martialArtsRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Music-related Movies")) {
                        for (var i = 0; i < musicNfid.length; i++) {
                          movieDataTest.add(musicNfid[i]);
                          movieImagesTest.add(musicImages[i]);
                          movieTitles.add(musicTitles[i]);
                          movieGenre.add(musicGenre[i]);
                          moviesSynopsis.add(musicSynopsis[i]);
                          movieYear.add(musicYear[i]);
                          movieRuntime.add(musicRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Sci-fi Movies")) {
                        for (var i = 0; i < scifiNfid.length; i++) {
                          movieDataTest.add(scifiNfid[i]);
                          movieImagesTest.add(scifiImages[i]);
                          movieTitles.add(scifiTitles[i]);
                          movieGenre.add(scifiGenre[i]);
                          moviesSynopsis.add(scifiSynopsis[i]);
                          movieYear.add(scifiYear[i]);
                          movieRuntime.add(scifiRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      if (chosenGenre.contains("Superheroes Movies")) {
                        for (var i = 0; i < superHeroNfid.length; i++) {
                          movieDataTest.add(superHeroNfid[i]);
                          movieImagesTest.add(superHeroImages[i]);
                          movieTitles.add(superHeroTitles[i]);
                          movieGenre.add(superHeroGenre[i]);
                          moviesSynopsis.add(superHeroSynopsis[i]);
                          movieYear.add(superHeroYear[i]);
                          movieRuntime.add(superHeroRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }

                      if (chosenGenre.contains("LGBTQ")) {
                        for (var i = 0; i < gayNfid.length; i++) {
                          movieDataTest.add(gayNfid[i]);
                          movieImagesTest.add(gayImages[i]);
                          movieTitles.add(gayTitles[i]);
                          movieGenre.add(gayGenre[i]);
                          moviesSynopsis.add(gaySynopsis[i]);
                          movieYear.add(gayYear[i]);
                          movieRuntime.add(gayRuntime[i]);
                        }
                        shuffle(
                            movieDataTest,
                            movieImagesTest,
                            movieTitles,
                            moviesSynopsis,
                            movieYear,
                            movieGenre,
                            movieRuntime);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Swiper(),
                              maintainState: true));
                    }
                  }),
            ],
          );
        });
      });
}
// void filterPop(context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('AlertDialog Title'),
//         content: SingleChildScrollView(
//           child: ListView(
//             children: values.keys.map((String key) {
//               return new CheckboxListTile(
//                 title: new Text(key),
//                 value: values[key],
//                 onChanged: (bool value) {
//                   print(value);
//                   print(values[key]);
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Approve'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// class FeaturesMultiSwitches extends StatefulWidget {
//   @override
//   _FeaturesMultiSwitchesState createState() => _FeaturesMultiSwitchesState();
// }

// List<String> chosenGenre = [];

// class _FeaturesMultiSwitchesState extends State<FeaturesMultiSwitches> {
//   List<String> _smartphone = [];
//   List<String> _days = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//       body: Column(
//         children: <Widget>[
//           const SizedBox(height: 15),
//           SmartSelect<String>.multiple(
//             title: 'Days',
//             value: chosenGenre,
//             choiceItems: choices.days,
//             onChange: (state) => setState(() => chosenGenre = state.value),
//           ),
//           const SizedBox(height: 7),
//         ],
//       ),
//     );
// return new Scaffold(
//   body: Column(
//     children: <Widget>[
//       // const SizedBox(height: 7),
//       // SmartSelect<String>.multiple(
//       //   title: 'Car',
//       //   value: _car,
//       //   onChange: (state) => setState(() => _car = state.value),
//       //   choiceItems: S2Choice.listFrom<String, Map>(
//       //     source: choices.cars,
//       //     value: (index, item) => item['value'],
//       //     title: (index, item) => item['title'],
//       //     group: (index, item) => item['brand'],
//       //   ),
//       //   choiceType: S2ChoiceType.switches,
//       //   choiceGrouped: true,
//       //   modalFilter: true,
//       //   tileBuilder: (context, state) {
//       //     return S2Tile.fromState(
//       //       state,
//       //       isTwoLine: true,
//       //       leading: const CircleAvatar(
//       //         backgroundImage: NetworkImage(
//       //             'https://source.unsplash.com/yeVtxxPxzbw/100x100'),
//       //       ),
//       //     );
//       //   },
//       // ),
//       const Divider(indent: 20),
//       SmartSelect<String>.multiple(
//         title: 'Smartphones',
//         value: _smartphone,
//         onChange: (state) => setState(() => _smartphone = state.value),
//         choiceType: S2ChoiceType.switches,
//         choiceItems: S2Choice.listFrom<String, Map>(
//           source: choices.smartphones,
//           value: (index, item) => item['id'],
//           title: (index, item) => item['name'],
//         ),
//         modalType: S2ModalType.bottomSheet,
//         modalFilter: true,
//         tileBuilder: (context, state) {
//           return S2Tile.fromState(
//             state,
//             isTwoLine: true,
//             leading: const CircleAvatar(
//               backgroundImage: NetworkImage(
//                   'https://source.unsplash.com/xsGxhtAsfSA/100x100'),
//             ),
//           );
//         },
//       ),
//       const Divider(indent: 20),
//       SmartSelect<String>.multiple(
//         title: 'Days',
//         value: _days,
//         onChange: (state) => setState(() => _days = state.value),
//         choiceItems: choices.days,
//         choiceType: S2ChoiceType.switches,
//         modalType: S2ModalType.popupDialog,
//         tileBuilder: (context, state) {
//           return S2Tile.fromState(
//             state,
//             isTwoLine: true,
//             leading: Container(
//               width: 40,
//               alignment: Alignment.center,
//               child: const Icon(Icons.calendar_today),
//             ),
//           );
//         },
//       ),
//       const SizedBox(height: 7),
//     ],
//   ),
// );
// }
// }
