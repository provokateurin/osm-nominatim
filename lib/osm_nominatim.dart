library osm_nominatim;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// OSM Nominatim helper
class Nominatim {
  /// Searches a places by their name
  ///
  /// Use either [query] with a free form string or any combination of
  /// [street], [city], [county], [state], [country] or [postalCode],
  /// but don't combine them.
  ///
  /// When using [query] commas are optional, but improve search
  /// performance.
  ///
  /// When using [street] you should provide it in the following format:
  /// `<housenumber> <streetname>`
  ///
  /// Using [addressDetails] will include a breakdown of the address into
  /// elements. Default is false.
  ///
  /// Using [extraTags] will include additional information in the result if
  /// available, e.g. wikipedia link, opening hours. Default is false.
  ///
  /// Using [nameDetails] will include a list of alternative names in the
  /// results. These may include language variants, references, operator and
  /// brand. Default is false.
  ///
  /// Using [language] will set the preferred language order for showing search
  /// results, overrides the value specified in the `Accept-Language` HTTP
  /// header if you are running in a browser. Either use a standard RFC2616
  /// accept-language string or a simple comma-separated list of language codes.
  ///
  /// Using [countryCodes] will limit search results to one or more countries.
  /// The country code must be the ISO 3166-1alpha2 code, e.g. `gb` for the
  /// United Kingdom, `de` for Germany.
  ///
  /// Using [excludePlaceIds] will skip certain OSM objects you don't want to
  /// appear in the search results. This can be used to broaden search results.
  /// For example, if a previous query only returned a few results, then
  /// including those here would cause the search to return other, less
  /// accurate, matches (if possible).
  ///
  /// Using [limit] will limit the number of returned results. Default is 10 and
  /// maximum is 50.
  ///
  /// Using [viewBox] will set the preferred area to find search results and an
  /// amenity only search is allowed. In this case, give the special keyword for
  /// the amenity in square brackets, e.g. `[pub]`.
  static Future<List<Place>> searchByName({
    String query,
    String street,
    String city,
    String county,
    String state,
    String country,
    String postalCode,
    bool addressDetails = false,
    bool extraTags = false,
    bool nameDetails = false,
    String language,
    List<String> countryCodes,
    List<String> excludePlaceIds,
    int limit = 10,
    ViewBox viewBox,
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
      'nominatim.openstreetmap.org',
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
          'countrycode': countryCodes.join(','),
        if (excludePlaceIds != null && excludePlaceIds.isNotEmpty)
          'exclude_place_ids': excludePlaceIds.join(','),
        if (limit != 10) 'limit': limit.toString(),
        if (viewBox != null)
          'viewbox':
              '${viewBox.westLongitude},${viewBox.southLatitude},${viewBox.eastLongitude},${viewBox.northLatitude}',
        if (viewBox != null) 'bounded': '1',
      },
    );
    final response = await http.get(uri);
    final data = json.decode(response.body) as List<dynamic>;
    return data
        .map<Place>((p) => Place.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Searches for a place by it's coordinates or OSM object
  ///
  /// Use either [lat] and [lon] or [osmType] and [osmId], but don't combine
  /// them.
  ///
  /// Using [addressDetails] will include a breakdown of the address into
  /// elements. Default is false.
  ///
  /// Using [extraTags] will include additional information in the result if
  /// available, e.g. wikipedia link, opening hours. Default is false.
  ///
  /// Using [nameDetails] will include a list of alternative names in the
  /// results. These may include language variants, references, operator and
  /// brand. Default is false.
  ///
  /// Using [language] will set the preferred language order for showing search
  /// results, overrides the value specified in the `Accept-Language` HTTP
  /// header if you are running in a browser. Either use a standard RFC2616
  /// accept-language string or a simple comma-separated list of language codes.
  ///
  /// Using [zoom] will set the level of detail required for the address.
  /// This is a number that corresponds roughly to the zoom level used in map
  /// frameworks like Leaflet.js, Openlayers etc. In terms of address details
  /// the zoom levels are as follows:
  /// <table>
  ///	<thead>
  ///		<tr>
  ///			<th>zoom</th>
  ///			<th>address detail</th>
  ///		</tr>
  ///	</thead>
  ///	<tbody>
  ///		<tr>
  ///			<td>3</td>
  ///			<td>country</td>
  ///		</tr>
  ///		<tr>
  ///			<td>5</td>
  ///			<td>state</td>
  ///		</tr>
  ///		<tr>
  ///			<td>8</td>
  ///			<td>county</td>
  ///		</tr>
  ///		<tr>
  ///			<td>10</td>
  ///			<td>city</td>
  ///		</tr>
  ///		<tr>
  ///			<td>14</td>
  ///			<td>suburb</td>
  ///		</tr>
  ///		<tr>
  ///			<td>16</td>
  ///			<td>major streets</td>
  ///		</tr>
  ///		<tr>
  ///			<td>17</td>
  ///			<td>major and minor streets</td>
  ///		</tr>
  ///		<tr>
  ///			<td>18</td>
  ///			<td>building</td>
  ///		</tr>
  ///	</tbody>
  /// </table>
  static Future<Place> reverseSearch({
    double lat,
    double lon,
    String osmType,
    int osmId,
    bool addressDetails = false,
    bool extraTags = false,
    bool nameDetails = false,
    String language,
    int zoom = 18,
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
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'format': 'jsonv2',
        if (lat != null) 'lat': lat.toString(),
        if (lon != null) 'lon': lon.toString(),
        if (osmType != null) 'osm_type': osmType,
        if (osmId != null) 'osm_id': osmId.toString(),
        if (addressDetails) 'addressdetails': '1',
        if (extraTags) 'extratags': '1',
        if (nameDetails) 'namedetails': '1',
        if (language != null) 'accept-language': language,
      },
    );
    final response = await http.get(uri);
    final data = json.decode(response.body);
    return Place.fromJson(data as Map<String, dynamic>);
  }
}

/// A place in the nominatim system
class Place {
  // ignore: public_member_api_docs
  Place({
    this.placeId,
    this.osmType,
    this.osmId,
    this.boundingBox,
    this.lat,
    this.lon,
    this.displayName,
    this.placeRank,
    this.category,
    this.type,
    this.importance,
    this.icon,
    this.address,
    this.extraTags,
    this.nameDetails,
  });

  // ignore: public_member_api_docs
  factory Place.fromJson(Map<String, dynamic> json) => Place(
        placeId: json['place_id'] as int,
        osmType: json['osm_type'] as String,
        osmId: json['osm_id'] as int,
        boundingBox: (json['boundingbox'] as List<dynamic>)
            .map<String>((e) => e as String)
            .toList(),
        lat: double.parse(json['lat'] as String),
        lon: double.parse(json['lon'] as String),
        displayName: json['display_name'] as String,
        category: json['category'] as String,
        type: json['type'] as String,
        importance: json['importance'] is int
            ? (json['importance'] as int).toDouble()
            : json['importance'] as double,
        icon: json['icon'] != null ? json['icon'] as String : null,
        address: json['address'] != null
            ? json['address'] as Map<String, dynamic>
            : null,
        extraTags: json['extratags'] != null
            ? json['extratags'] as Map<String, dynamic>
            : null,
        nameDetails: json['namedetails'] != null
            ? json['namedetails'] as Map<String, dynamic>
            : null,
      );

  /// Reference to the Nominatim internal database ID
  /// See https://nominatim.org/release-docs/latest/api/Output/#place_id-is-not-a-persistent-id
  final int placeId;

  /// Reference to the OSM object
  final String osmType;

  /// Reference to the OSM object
  final int osmId;

  /// Area of corner coordinates
  /// See https://nominatim.org/release-docs/latest/api/Output/#boundingbox
  final List<String> boundingBox;

  /// Latitude of the centroid of the object
  final double lat;

  /// Longitude of the centroid of the object
  final double lon;

  /// Full comma-separated address
  final String displayName;

  /// Search rank of the object
  final int placeRank;

  /// Key of the main OSM tag
  final String category;

  /// Value of the main OSM tag
  final String type;

  /// Computed importance rank
  final double importance;

  /// Link to class icon (if available)
  final String icon;

  /// Map of address details
  /// Only with [Nominatim.searchByName(addressDetails: true)]
  /// See https://nominatim.org/release-docs/latest/api/Output/#addressdetails
  final Map<String, dynamic> address;

  /// Map with additional useful tags like website or max speed
  /// Only with [Nominatim.searchByName(extraTags: true)]
  final Map<String, dynamic> extraTags;

  /// Map with full list of available names including ref etc.
  /// Only with [Nominatim.searchByName(nameDetails: true)]
  final Map<String, dynamic> nameDetails;
}

/// View box for searching
class ViewBox {
  // ignore: public_member_api_docs
  ViewBox(
    this.northLatitude,
    this.southLatitude,
    this.eastLongitude,
    this.westLongitude,
  )   : assert(
          northLatitude > southLatitude,
          'north latitude has to be greater than south latitude',
        ),
        assert(
          eastLongitude > westLongitude,
          'east longitude has to be greater than west longitude',
        ),
        assert(
          northLatitude <= 90,
          'north latitude must be smaller than or equals 90',
        ),
        assert(
          southLatitude >= -90,
          'south latitude must be greater than or equals -90',
        ),
        assert(
          eastLongitude <= 180,
          'east longitude must be smaller than or equals 180',
        ),
        assert(
          westLongitude >= -180,
          'east longitude must be greater than or equals -180',
        );

  /// North boundary of the view box
  final double northLatitude;

  /// South boundary of the view box
  final double southLatitude;

  /// East boundary of the view box
  final double eastLongitude;

  /// West boundary of the view box
  final double westLongitude;
}
