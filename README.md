A library to perform OSM Nominatim searches also supporting reverse searches.
The documentation comments are mostly copied from [https://nominatim.org/release-docs/latest](https://nominatim.org/release-docs/latest).

## Usage
```dart
import 'package:osm_nominatim/osm_nominatim.dart';

Future main() async {
  final nominatim = Nominatim(
    userAgent: 'Dart osm_nominatim example',
  );

  final searchResult = await nominatim.searchByName(
    query: 'bakery in berlin wedding',
    limit: 1,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
  final reverseSearchResult = await nominatim.reverseSearch(
    lat: 50.1,
    lon: 6.3,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
}
```
