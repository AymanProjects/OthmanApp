import 'package:flutter/material.dart';
import 'package:othman/Screens/Suras/VerseWidget.dart';
import 'package:othman/Services/QuranAPI.dart';
import 'package:othman/components/EpicDivider.dart';
import 'package:othman/models/Location.dart';
import 'package:othman/models/Sura.dart';
import 'package:othman/models/Verse.dart';

class LocationScreen extends StatelessWidget {
  final Location location;
  LocationScreen(this.location);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        child: Text(
          location.name,
          textDirection: TextDirection.rtl,
        ),
      )),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        children: [
          Text(location.name),
          Text('ذكر في القران ؟ مرة'),
          EpicDivider(),
          FutureBuilder(
            future: QuranAPI.getAllVersesOfLocation(location.id),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                List<Verse> verses = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 25,
                      thickness: 1,
                      endIndent: 40,
                      indent: 40,
                    );
                  },
                  itemCount: verses.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder<Sura>(
                          future: QuranAPI.getSura(verses[index].suraNumber),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "${snapshot.data.name}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        VerseWidget(
                          verse: verses[index],
                        ),
                      ],
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            },
          ),
          //  EpicDivider(),
          // Text('احداث مرتبطة بالشخصية'),
          // FutureBuilder<List<Story>>(
          //   future: QuranAPI.getAllStoriesOfCharacter(character.id),
          //   builder: (BuildContext context, snapshot) {
          //     if (snapshot.hasData) {
          //       if (snapshot.data.isNotEmpty) {
          //         List<Story> stories = snapshot.data;
          //         return ListView.separated(
          //           shrinkWrap: true,
          //           physics: ClampingScrollPhysics(),
          //           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          //           separatorBuilder: (context, index) {
          //             return Divider(
          //               height: 25,
          //               thickness: 1,
          //               endIndent: 40,
          //               indent: 40,
          //             );
          //           },
          //           itemCount: stories.length,
          //           itemBuilder: (context, index) {
          //             return Text(stories[index].name);
          //           },
          //         );
          //       } else {
          //         return Text("لايوجد");
          //       }
          //     }
          //     return CircularProgressIndicator();
          //   },
          // ),
        ],
      ),
    );
  }
}
