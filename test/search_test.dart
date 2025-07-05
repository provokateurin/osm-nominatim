import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Search',
    () async {
      final nomination = Nominatim();

      final searchResult = await nomination.searchByName(
        query: 'Fallujah',
        limit: 1,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      expect(searchResult, hasLength(1));
      // Don't test for the actual data since it might change
      expect(searchResult.single.address, isNotNull);
      expect(searchResult.single.extraTags, isNotNull);
      expect(searchResult.single.nameDetails, isNotNull);
    },
  );
}
