import 'package:equatable/equatable.dart';

// ════════════════════════════════════════════════════════════════════════════════
// AffiliateDealModel
// Represents a single travel / accommodation deal shown in the sticky sidebar.
// Sourced from affiliate APIs (Booking.com, TravelPayouts, etc.).
// ⚠ No hardcoded prices, names, or images — all fields come from the API.
// ════════════════════════════════════════════════════════════════════════════════

/// Discriminated union of affiliate deal categories shown in the sidebar.
enum AffiliateDealType {
  /// Airline / flight deal
  flight,

  /// Hotel / accommodation deal
  hotel,

  /// Car or transport rental
  rental,
}

class AffiliateDealModel extends Equatable {
  const AffiliateDealModel({
    required this.id,
    required this.type,
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.price,
    this.originalPrice,
    this.currency,
    this.priceUnit,
    this.discountPercentage,
    this.imageUrl,
    this.affiliateUrl,
    this.partnerName,
    this.partnerLogoUrl,
    this.rating,
    this.reviewCount,
    this.destinationCity,
    this.originCity,
  });

  final String id;
  final AffiliateDealType type;

  /// Deal headline in English (e.g. "Paris to Berlin, Round Trip")
  final String? title;

  /// Deal headline in Arabic
  final String? titleAr;

  /// Secondary line in English (e.g. "Economy class · 2h 10m")
  final String? subtitle;

  /// Secondary line in Arabic
  final String? subtitleAr;

  /// Deal price (numeric, no currency symbol)
  final double? price;

  /// Crossed-out original price before discount
  final double? originalPrice;

  /// Currency symbol from API (e.g. '€', '$', 'AED')
  final String? currency;

  /// Price unit label (e.g. 'night', 'trip', 'one-way')
  final String? priceUnit;

  /// Discount badge as integer percentage (e.g. 20 → "20% off")
  final int? discountPercentage;

  /// CDN URL of the deal cover image
  final String? imageUrl;

  /// Tracked affiliate deep-link URL (opens in new tab)
  final String? affiliateUrl;

  /// Affiliate partner display name (e.g. 'Booking.com', 'TravelPayouts')
  final String? partnerName;

  /// Affiliate partner logo image URL
  final String? partnerLogoUrl;

  /// Hotel / property star or user rating (0.0–5.0)
  final double? rating;

  /// Number of user reviews backing [rating]
  final int? reviewCount;

  /// Destination city name (localised via API)
  final String? destinationCity;

  /// Origin city (for flight deals)
  final String? originCity;

  // ── Deserialisation ──────────────────────────────────────────────────────
  factory AffiliateDealModel.fromJson(Map<String, dynamic> json) {
    return AffiliateDealModel(
      id: json['id']?.toString() ?? '',
      type: AffiliateDealType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? ''),
        orElse: () => AffiliateDealType.hotel,
      ),
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      subtitle: json['subtitle'] as String?,
      subtitleAr: json['subtitle_ar'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      priceUnit: json['price_unit'] as String?,
      discountPercentage: json['discount_percentage'] as int?,
      imageUrl: json['image_url'] as String?,
      affiliateUrl: json['affiliate_url'] as String?,
      partnerName: json['partner_name'] as String?,
      partnerLogoUrl: json['partner_logo_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      destinationCity: json['destination_city'] as String?,
      originCity: json['origin_city'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'title_ar': titleAr,
        'subtitle': subtitle,
        'subtitle_ar': subtitleAr,
        'price': price,
        'original_price': originalPrice,
        'currency': currency,
        'price_unit': priceUnit,
        'discount_percentage': discountPercentage,
        'image_url': imageUrl,
        'affiliate_url': affiliateUrl,
        'partner_name': partnerName,
        'partner_logo_url': partnerLogoUrl,
        'rating': rating,
        'review_count': reviewCount,
        'destination_city': destinationCity,
        'origin_city': originCity,
      };

  /// Formatted price string, e.g. "€150" or "€150 / night"
  String? formattedPrice({String fallbackCurrency = '€'}) {
    if (price == null) return null;
    final curr = currency ?? fallbackCurrency;
    final unit = priceUnit;
    final base = '$curr${price!.toStringAsFixed(0)}';
    return unit != null ? '$base / $unit' : base;
  }

  @override
  List<Object?> get props => [
        id, type, title, titleAr, subtitle, subtitleAr,
        price, originalPrice, currency, priceUnit, discountPercentage,
        imageUrl, affiliateUrl, partnerName, partnerLogoUrl,
        rating, reviewCount, destinationCity, originCity,
      ];
}
