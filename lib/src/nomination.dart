import 'package:http/http.dart' as http;
import 'package:osm_nominatim/src/nomination_helpers.dart';

import 'models/place.dart';
import 'models/view_box.dart';
import 'network/intercepted_client.dart';

/// OSM Nominatim helper
class Nominatim {
  factory Nominatim({http.Client? client}) {
    if (client != null) {
      return Nominatim._withClient(client);
    }
    return _singleton;
  }
  Nominatim._withClient(http.Client client) : _client = client;

  Nominatim._internal() : _client = InterceptedClient(http.Client());
  // Nominatim({http.Client? client})
  //     : _client = client ?? InterceptedClient(http.Client());
  // final http.Client _client;

  static final Nominatim _singleton = Nominatim._internal();

  final http.Client _client;
  static Nominatim get instance => Nominatim();

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
  Future<List<Place>> searchByName({
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
  }) async =>
      NominationHelpers.searchByName(_client,
          query: query,
          street: street,
          city: city,
          county: county,
          state: state,
          country: country,
          postalCode: postalCode,
          addressDetails: addressDetails,
          extraTags: extraTags,
          nameDetails: nameDetails,
          language: language,
          countryCodes: countryCodes,
          excludePlaceIds: excludePlaceIds,
          limit: limit,
          viewBox: viewBox,
          host: host);

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
  Future<Place?> reverseSearch({
    double? latitude,
    double? longitude,
    String? osmType,
    int? osmId,
    bool addressDetails = false,
    bool extraTags = false,
    bool nameDetails = false,
    String? language,
    int zoom = 18,
    String host = 'nominatim.openstreetmap.org',
  }) =>
      NominationHelpers.reverseSearch(
        _client,
        lat: latitude,
        lon: longitude,
        osmType: osmType,
        osmId: osmId,
        addressDetails: addressDetails,
        extraTags: extraTags,
        nameDetails: nameDetails,
        language: language,
        zoom: zoom,
        host: host,
      );
}
