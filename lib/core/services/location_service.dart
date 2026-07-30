import 'dart:convert';
import 'package:http/http.dart' as http;

// ════════════════════════════════════════════════════════════════════════════════
// UserLocationInfo
// Helper class to encapsulate the result of the IP-sensing location lookup.
// ════════════════════════════════════════════════════════════════════════════════
class UserLocationInfo {
  const UserLocationInfo({
    required this.ip,
    required this.countryCode,
    required this.countryName,
    required this.latitude,
    required this.longitude,
    required this.inEu,
  });

  final String ip;
  final String countryCode;
  final String countryName;
  final double latitude;
  final double longitude;
  final bool inEu;

  @override
  String toString() =>
      'UserLocationInfo(ip: $ip, countryCode: $countryCode, inEu: $inEu, lat: $latitude, lng: $longitude)';
}

// ════════════════════════════════════════════════════════════════════════════════
// LocationService
// Performs IP-sensing geo-location checks.
// Uses free JSON IP lookup endpoints (ipapi.co) to determine the user's IP coordinates,
// country, and whether they reside inside the European Union (EU).
// ════════════════════════════════════════════════════════════════════════════════
class LocationService {
  // Pre-defined set of ISO 3166-1 alpha-2 country codes belonging to the European Union (EU)
  static const Set<String> _euCountryCodes = {
    'AT', 'BE', 'BG', 'CY', 'CZ', 'DE', 'DK', 'EE', 'ES', 'FI',
    'FR', 'GR', 'HR', 'HU', 'IE', 'IT', 'LT', 'LU', 'LV', 'MT',
    'NL', 'PL', 'PT', 'RO', 'SE', 'SI', 'SK'
  };

  /// Sense user location by performing a lightweight geo-IP lookup.
  /// Falls back gracefully to sensible non-EU mock coordinates if offline or failed.
  Future<UserLocationInfo> detectUserLocation() async {
    try {
      final response = await http
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        
        final String ip = data['ip']?.toString() ?? '127.0.0.1';
        final String countryCode = (data['country_code']?.toString() ?? 'US').toUpperCase();
        final String countryName = data['country_name']?.toString() ?? 'United States';
        final double lat = (data['latitude'] as num?)?.toDouble() ?? 37.0902;
        final double lng = (data['longitude'] as num?)?.toDouble() ?? -95.7129;
        
        // Determine EU membership (check in_eu flag or match against country codes set)
        final bool inEu = (data['in_eu'] as bool?) ?? _euCountryCodes.contains(countryCode);

        return UserLocationInfo(
          ip: ip,
          countryCode: countryCode,
          countryName: countryName,
          latitude: lat,
          longitude: lng,
          inEu: inEu,
        );
      }
    } catch (_) {
      // Fallback silently if lookup times out or fails (no network, API limit, etc.)
    }

    // Default mock location: Dubai, UAE (Outside EU)
    return const UserLocationInfo(
      ip: '8.8.8.8',
      countryCode: 'AE',
      countryName: 'United Arab Emirates',
      latitude: 25.2048,
      longitude: 55.2708,
      inEu: false,
    );
  }
}
