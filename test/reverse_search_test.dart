import 'package:http/http.dart' as http;
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:test/test.dart';

void main() {
  test('Reverse search', () async {
    final nomination = Nominatim(
      client: InterceptedClient(http.Client()),
    );

    final reverseSearchResult = await nomination.reverseSearch(
      latitude: 33.35691398606316,
      longitude: 43.79147974615681,
      addressDetails: true,
      // extraTags: false,
      // nameDetails: false,
    );
    // Don't test for the actual data since it might change
    expect(reverseSearchResult?.address, isNotNull);
    expect(reverseSearchResult?.displayName, isNotNull);
    expect(reverseSearchResult?.extraTags, isNull);
    expect(reverseSearchResult?.nameDetails, isNull);
  });
}
