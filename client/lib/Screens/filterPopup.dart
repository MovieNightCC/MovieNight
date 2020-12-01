import 'package:flutter/material.dart';

Map<String, bool> values = {
  'foo': true,
  'bar': false,
};

List<String> _texts = [
  "InduceSmile.com",
  "Flutter.io",
  "google.com",
  "youtube.com",
  "yahoo.com",
  "gmail.com"
];

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

void filterPop(context) {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return new AlertDialog(
            title: new Text("What you want to watch:"),
            content: Container(
              width: double.maxFinite,
              child: ListView(children: <Widget>[
                CheckboxListTile(
                  title: Text("All Movies"),
                  value: clickedAll,
                  onChanged: (val) {
                    setState(() {
                      clickedAll = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Anime"),
                  value: clickedAnime,
                  onChanged: (val) {
                    setState(() {
                      clickedAnime = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("LGBTQ Movies"),
                  value: clickedLGBT,
                  onChanged: (val) {
                    setState(() {
                      clickedLGBT = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Horror/Thrillers"),
                  value: clickedHorror,
                  onChanged: (val) {
                    setState(() {
                      clickedHorror = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Independent Films"),
                  value: clickedIndie,
                  onChanged: (val) {
                    setState(() {
                      clickedIndie = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Japanese Movies"),
                  value: clickedJapan,
                  onChanged: (val) {
                    setState(() {
                      clickedJapan = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Korean Movies"),
                  value: clickedKorea,
                  onChanged: (val) {
                    setState(() {
                      clickedKorea = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Martial Arts Movies"),
                  value: clickedMartial,
                  onChanged: (val) {
                    setState(() {
                      clickedMartial = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Music-related Movies"),
                  value: clickedMusic,
                  onChanged: (val) {
                    setState(() {
                      clickedMusic = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Sci-fi Movies"),
                  value: clickedScifi,
                  onChanged: (val) {
                    setState(() {
                      clickedScifi = val;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Superheroes Movies"),
                  value: clickedSuperhero,
                  onChanged: (val) {
                    setState(() {
                      clickedSuperhero = val;
                    });
                  },
                )
              ]),
            ),
            actions: <Widget>[
              new FlatButton(
                child: const Text("Exit"),
                onPressed: () => Navigator.pop(context),
              ),
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