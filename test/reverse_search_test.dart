import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:test/test.dart';

void main() {
  test('Reverse search', () async {
    final nominatim = Nominatim(userAgent: 'Dart osm_nominatim test');
    final reverseSearchResult = await nominatim.reverseSearch(
      lat: 50.1,
      lon: 6.3,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    // Don't test for the actual data since it might change
    expect(reverseSearchResult.address, isNotNull);
    expect(reverseSearchResult.extraTags, isNotNull);
    expect(reverseSearchResult.nameDetails, isNotNull);
  });
}
