import 'dart:io';

import 'package:example_flutter/client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:osm_nominatim/osm_nominatim.dart';

void main() {
  runApp(const MainApp());
}

double latitude = 0.0;
double longitude = 0.0;
String name = '';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Text('OpenStreetMap Nominatim Example'),

                    TextFormField(
                      onChanged: (value) {
                        latitude = double.tryParse(value) ?? 0.0;
                      },
                      decoration: InputDecoration(
                        labelText: 'latitude',
                        hintText: 'Enter latitude',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'longitude',
                        hintText: 'Enter longitude',
                      ),
                      onChanged: (value) {
                        longitude = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'name',
                        hintText: 'Enter name',
                      ),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          var res = await Nominatim.instance.reverseSearch(
                            latitude: latitude,
                            longitude: longitude,
                            addressDetails: false,
                            extraTags: false,
                            nameDetails: false,
                          );
                          if (res != null) {
                            print('Place found: ${res.displayName}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Place found: ${res.displayName}',
                                ),
                              ),
                            );
                          } else {
                            print('No place found for the given coordinates.');
                          }
                        } catch (e, s) {
                          print(e);
                          print(s);
                        }
                      },
                      child: Text('Reverse location - with internal client'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var client = AppClient(
                          headers: {'User-Agent': 'MyApp/1.0'},
                        );
                        var nomination = Nominatim(client: client);

                        try {
                          var res = await nomination.reverseSearch(
                            latitude: latitude,
                            longitude: longitude,
                            addressDetails: false,
                            extraTags: false,
                            nameDetails: false,
                          );
                          if (res != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Place found: ${res.displayName}',
                                ),
                              ),
                            );
                          } else {
                            debugPrint(
                              'No place found for the given coordinates.',
                            );
                          }
                        } catch (e, s) {
                          debugPrint(e.toString());
                          debugPrint(s.toString());
                        }
                      },
                      child: Text('Reverse location - with client of app'),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        var cl = InterceptedClient(http.Client(), {
                          'User-Agent': 'osm_nominatim flutter /1.0',
                        });

                        // var client = http.Client();
                        var nomination = Nominatim(client: cl);
                        // var nomination = Nominatim();
                        print(name);

                        try {
                          var res = await nomination.searchByName(
                            query: name,
                            limit: 1,
                            addressDetails: false,
                            extraTags: false,
                            nameDetails: false,
                          );
                          if (res.isNotEmpty) {
                            print('Place found: ${res.first.displayName}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Place found: ${res.first.displayName}',
                                ),
                              ),
                            );
                          } else {
                            print('No place found for the given coordinates.');
                          }
                        } catch (e, s) {
                          print(e);
                          print(s);
                        }
                      },
                      child: Text('Search name'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
