

<h1 align="center">
  <br>
  <img src="https://github.com/provokateurin/osm-nominatim/blob/main/.github/osm_nominatim_logo.png" alt="OSM Nominatim" width="250">
</h1>



<h1 align="center"> <a href="https://github.com/Turfjs/turf">osm_nominatim</a>-find locations on Earth by name or address in pure Dart.
</h1>
<br>


---




 

A Dart library for performing OpenStreetMap Nominatim searches and reverse geocoding, with full support for custom HTTP clients, global headers, and Flutter integration.

---
The documentation comments are mostly copied from [https://nominatim.org/release-docs/latest](https://nominatim.org/release-docs/latest).

<div align="center">
  <a href="https://pub.dev/packages/osm_nominatim">
    <img src="https://img.shields.io/pub/v/osm_nominatim.svg" alt="pub package">
  </a>
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</div>

---

## Features

- **Forward geocoding**: Search for places by name or structured address.
- **Reverse geocoding**: Find address details for given coordinates.
- **Custom HTTP clients**: Use your own client to set global headers (e.g., User-Agent).
- **Flutter ready**: Easily integrate with Flutter apps.
- **Well-documented**: API docs and usage examples included.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  osm_nominatim: <latest-version>
```

---

## Usage

### Basic Search Example

```dart
import 'package:osm_nominatim/osm_nominatim.dart';

Future<void> main() async {
  final results = await Nominatim.instance.searchByName(
    query: 'bakery in berlin wedding',
    limit: 1,
    nameDetails: true,
  );
  if (results.isNotEmpty) {
    print('Found: ${results.first.displayName}');
  }
}
```

### Reverse Geocoding Example

```dart
import 'package:osm_nominatim/osm_nominatim.dart';

Future<void> main() async {
  final place = await Nominatim.instance.reverseSearch(
    latitude: 52.5200,
    longitude: 13.4050,
    addressDetails: true,
  );
  if (place != null) {
    print('Found: ${place.displayName}');
  }
}
```

### Using a Custom HTTP Client with Global Headers

You can provide your own HTTP client to set global headers (such as a custom User-Agent):

```dart
import 'package:http/http.dart' as http;
import 'package:osm_nominatim/osm_nominatim.dart';

class AppClient extends http.BaseClient {
  final Map<String, String> globalHeaders;
  final http.Client _inner = http.Client();

  AppClient({Map<String, String>? headers}) : globalHeaders = headers ?? {};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(globalHeaders);
    return _inner.send(request);
  }
}

void main() async {
  var client = AppClient(headers: {'User-Agent': 'MyApp/1.0'});
  var nominatim = Nominatim(client: client);

  final place = await nominatim.reverseSearch(
    latitude: 52.52,
    longitude: 13.405,
    addressDetails: true,
  );
  print(place?.displayName);
}
```

---

## Flutter Example

A complete Flutter example is available in the [example_flutter](example_flutter/) directory.

```dart
ElevatedButton(
  onPressed: () async {
    var client = AppClient(headers: {'User-Agent': 'MyApp/1.0'});
    var nominatim = Nominatim(client: client);

    var res = await nominatim.reverseSearch(
      latitude: latitude,
      longitude: longitude,
      addressDetails: false,
      extraTags: false,
      nameDetails: false,
    );
    if (res != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place found: ${res.displayName}')),
      );
    }
  },
  child: Text('Reverse location - with client of app'),
)
```

---

## API Reference

- [Nominatim API Documentation](https://nominatim.org/release-docs/latest/api/Overview/)
- [Dart API Docs](https://pub.dev/documentation/osm_nominatim/latest/)

---

## License

MIT License

---

## Contributing

Contributions are welcome! Please open issues or pull requests on [GitHub](https://github.com/provokateurin/osm-nominatim).

---

## Acknowledgements

- [OpenStreetMap Nominatim](https://nominatim.org/)
- [Dart](https://dart.dev/)