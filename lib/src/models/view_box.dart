

/// View box for searching
class ViewBox {
  // ignore: public_member_api_docs
  ViewBox(
    this.northLatitude,
    this.southLatitude,
    this.eastLongitude,
    this.westLongitude,
  )   : assert(
          northLatitude > southLatitude,
          'north latitude has to be greater than south latitude',
        ),
        assert(
          eastLongitude > westLongitude,
          'east longitude has to be greater than west longitude',
        ),
        assert(
          northLatitude <= 90,
          'north latitude must be smaller than or equals 90',
        ),
        assert(
          southLatitude >= -90,
          'south latitude must be greater than or equals -90',
        ),
        assert(
          eastLongitude <= 180,
          'east longitude must be smaller than or equals 180',
        ),
        assert(
          westLongitude >= -180,
          'east longitude must be greater than or equals -180',
        );

  /// North boundary of the view box
  final double northLatitude;

  /// South boundary of the view box
  final double southLatitude;

  /// East boundary of the view box
  final double eastLongitude;

  /// West boundary of the view box
  final double westLongitude;
}
