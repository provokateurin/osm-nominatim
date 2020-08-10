A library to perform OSM Nominatim searches also supporting reverse searches.
The documentation comments are mostly copied from [https://nominatim.org/release-docs/latest](https://nominatim.org/release-docs/latest).

## Usage
```dart
import 'package:osm_nominatim/osm_nominatim.dart';

Future main() async {
  final searchResult = await Nominatim.searchByName(
    query: 'bakery in berlin wedding',
    limit: 1,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
  final reverseSearchResult = await Nominatim.reverseSearch(
    lat: '50',
    lon: '6',
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );
}
```