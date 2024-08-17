import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/pages/proximity_detection_page.dart';  // Update with your actual import

void main() {
  group('ProximityDetectionLogic', () {
    late ProximityDetectionLogic logic;

    setUp(() {
      logic = ProximityDetectionLogic();
    });

    test('checkNearbyDevices calculates distances correctly', () {
      final testLocations = {
        'current_user': {
          'latitude': 40.7128,
          'longitude': -74.0060,
        },
        'nearby_user': {
          'latitude': 40.7129,
          'longitude': -74.0061,
        },
        'far_user': {
          'latitude': 41.8781,
          'longitude': -87.6298,
        },
      };

      final result = logic.checkNearbyDevices(testLocations, 'current_user');

      expect(result.length, 1);
      expect(result[0]['id'], 'nearby_user');
      expect(result[0]['distance'], lessThan(100));
    });

    test('calculateDistance returns expected value', () {
      double distance = logic.calculateDistance(40.7128, -74.0060, 40.7129, -74.0061);
      expect(distance, closeTo(22.2, 0.1));  // Approximately 22.2 meters
    });
  });
}