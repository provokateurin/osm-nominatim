import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:osm_nominatim/osm_nominatim.dart';

class NominationHelpers {
  static Future<List<Place>> searchByName(
    http.Client client, {
    String? query,
    String? street,
    String? city,
    String? county,
    String? state,
    String? country,
    String? postalCode,
    bool addressDetails = false,
    bool extraTags = false,
    bool nameDetails = false,
    String? language,
    List<String>? countryCodes,
    List<String>? excludePlaceIds,
    int limit = 10,
    ViewBox? viewBox,
    String host = 'nominatim.openstreetmap.org',
  }) async {
    if (query == null) {
      assert(
        street != null ||
            city != null ||
            county != null ||
            state != null ||
            country != null ||
            postalCode != null,
        'Any search parameter is needed for a structured request',
      );
    } else {
      assert(
        street == null &&
            city == null &&
            county == null &&
            state == null &&
            country == null &&
            postalCode == null,
        'Do not use query and any other search parameter together',
      );
    }
    assert(limit > 0, 'Limit has to be greater than zero');
    assert(limit <= 50, 'Limit has to be smaller or equals than 50');
    final uri = Uri.https(
      host,
      '/search',
      {
        'format': 'jsonv2',
        if (query != null) 'q': query,
        if (street != null) 'street': street,
        if (city != null) 'city': city,
        if (county != null) 'county': county,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (postalCode != null) 'postalcode': postalCode,
        if (addressDetails) 'addressdetails': '1',
        if (extraTags) 'extratags': '1',
        if (nameDetails) 'namedetails': '1',
        if (language != null) 'accept-language': language,
        if (countryCodes != null && countryCodes.isNotEmpty)
          'countrycodes': countryCodes.join(','),
        if (excludePlaceIds != null && excludePlaceIds.isNotEmpty)
          'exclude_place_ids': excludePlaceIds.join(','),
        if (limit != 10) 'limit': limit.toString(),
        if (viewBox != null)
          'viewbox':
              '${viewBox.westLongitude},${viewBox.southLatitude},${viewBox.eastLongitude},${viewBox.northLatitude}',
        if (viewBox != null) 'bounded': '1',
      },
    );

    try {
      final response = await client.get(
        uri,
      );
      final data = json.decode(response.body) as List<dynamic>;
      return data
          .map<Place>((p) => Place.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching data: $e');
      return [];
    }
    // final response = await http.get(uri);
    // final data = json.decode(response.body) as List<dynamic>;
    // return data
    //     .map<Place>((p) => Place.fromJson(p as Map<String, dynamic>))
    //     .toList();
  }

  static Future<Place?> reverseSearch(
    http.Client client, {
    double? lat,
    double? lon,
    String? osmType,
    int? osmId,
    bool addressDetails = false,
    bool extraTags = false,
    bool nameDetails = false,
    String? language,
    int zoom = 18,
    String host = 'nominatim.openstreetmap.org',
  }) async {
    final notNullParameters =
        [lat, lon, osmType, osmId].where((e) => e != null).length;
    assert(
      notNullParameters == 2,
      'Either provide lat and lon or osmType and osmId',
    );
    assert(
      (lat != null && lon != null && osmType == null && osmId == null) ||
          (lat == null && lon == null && osmType != null && osmId != null),
      'Do not mix coordinates and OSM object',
    );
    assert(
      ['N', 'W', 'R', null].contains(osmType),
      'osmType needs to be one of N, W, R',
    );
    assert(
      zoom >= 0 && zoom <= 18,
      'Zoom needs to be between 0 and 18',
    );
    final uri = Uri.https(
      host,
      '/reverse',
      {
        'format': 'jsonv2',
        'zoom': zoom.toString(),
        if (lat != null) 'lat': lat.toString(),
        if (lon != null) 'lon': lon.toString(),
        if (osmType != null) 'osm_type': osmType,
        if (osmId != null) 'osm_id': osmId.toString(),
        if (addressDetails == false) 'addressdetails': '1',
        if (extraTags) 'extratags': '1',
        if (nameDetails) 'namedetails': '1',
        if (language != null) 'accept-language': language,
      },
    );

    try {
      // final client = ;
      // final response = await client.get(uri);
      final response = await client.get(
        uri,
      );
      log(response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      return Place.fromJson(data);
    } catch (e) {
      log('Error fetching data: $e');
      // rethrow;
      return null;
    }
    // final response = await http.get(uri);
    // log(response.body);
    // final data = json.decode(response.body) as Map<String, dynamic>;
    // if (data['error'] != null) {
    //   throw Exception(data['error']);
    // }
    // return Place.fromJson(data);
  }
}
