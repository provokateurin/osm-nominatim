import 'package:osm_nominatim/osm_nominatim.dart';

Future main() async {
  Nominatim.setHttpClient(http.Client()); // Optional
  Nominatim.setDefaultHeaders({
    'User-Agent': 'osm_nominatim/1.0',
  });
  final searchResult = await Nominatim.searchByName(
    query: 'bakery in berlin wedding',
    limit: 1,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
  print(searchResult.single.displayName);
  print(searchResult.single.address);
  print(searchResult.single.extraTags);
  print(searchResult.single.nameDetails);

  print('');

  final reverseSearchResult = await Nominatim.reverseSearch(
    lat: 50.1,
    lon: 6.2,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
  print(reverseSearchResult.displayName);
  print(reverseSearchResult.address);
  print(reverseSearchResult.extraTags);
  print(reverseSearchResult.nameDetails);
}
