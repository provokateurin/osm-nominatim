




/// A place in the nominatim system
class Place {
  // ignore: public_member_api_docs
  Place({
    required this.placeId,
    required this.osmType,
    required this.osmId,
    required this.boundingBox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.placeRank,
    required this.category,
    required this.type,
    required this.importance,
    this.icon,
    this.address,
    this.extraTags,
    this.nameDetails,
  });

  // ignore: public_member_api_docs
  factory Place.fromJson(Map<String, dynamic> json) => Place(
        placeId: json['place_id'] as int,
        osmType: json['osm_type'] != null ? json['osm_type'] as String : null,
        osmId: json['osm_id'] != null ? json['osm_id'] as int : null,
        boundingBox: (json['boundingbox'] as List<dynamic>)
            .map<String>((e) => e as String)
            .toList(),
        lat: double.parse(json['lat'] as String),
        lon: double.parse(json['lon'] as String),
        displayName: json['display_name'] as String,
        placeRank: json['place_rank'] as int,
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
  final String? osmType;

  /// Reference to the OSM object
  final int? osmId;

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
  final String? icon;

  /// Map of address details
  /// Only with [Nominatim.searchByName(addressDetails: true)]
  /// See https://nominatim.org/release-docs/latest/api/Output/#addressdetails
  final Map<String, dynamic>? address;

  /// Map with additional useful tags like website or max speed
  /// Only with [Nominatim.searchByName(extraTags: true)]
  final Map<String, dynamic>? extraTags;

  /// Map with full list of available names including ref etc.
  /// Only with [Nominatim.searchByName(nameDetails: true)]
  final Map<String, dynamic>? nameDetails;
}
