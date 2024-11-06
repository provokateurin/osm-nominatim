A library to perform OSM Nominatim searches also supporting reverse searches.
The documentation comments are mostly copied from [https://nominatim.org/release-docs/latest](https://nominatim.org/release-docs/latest).

## Usage
```dart
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
  final reverseSearchResult = await Nominatim.reverseSearch(
    lat: 50.1,
    lon: 6.2,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
}
```