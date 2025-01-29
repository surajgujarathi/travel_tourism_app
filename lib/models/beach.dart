class Beach {
  final String id;
  final String name;
  final String image;
  final String location;
  final double waveHeight;
  final double windSpeed;
  final String description;
  final List<String> activities;
  bool isFavorite;
  double rating;

  Beach({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.waveHeight,
    required this.windSpeed,
    required this.description,
    required this.activities,
    this.isFavorite = false,
    this.rating = 0.0,
  });

  // Water Quality Evaluation
  String get waterQuality {
    return SuitabilityAlgorithm.evaluateWaterQuality({
      'current': {'wave_height': waveHeight, 'wind_speed': windSpeed}
    });
  }

  // Determines if the beach is suitable
  bool get isSuitable => waterQuality == 'Good';

  // Convert Beach object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'location': location,
      'waveHeight': waveHeight,
      'windSpeed': windSpeed,
      'description': description,
      'activities': activities,
      'isFavorite': isFavorite,
      'rating': rating,
    };
  }

  // Create a Beach object from Firestore data
  static Beach fromMap(Map<String, dynamic> map) {
    return Beach(
      id: map['id'] ?? '', // Default to empty string if id is null
      name: map['name'] ?? '', // Default to empty string if name is null
      image: map['image'] ?? '', // Default to empty string if image is null
      location:
          map['location'] ?? '', // Default to empty string if location is null
      waveHeight: map['waveHeight'] != null
          ? double.tryParse(map['waveHeight'].toString()) ?? 0.0
          : 0.0,
      windSpeed: map['windSpeed'] != null
          ? double.tryParse(map['windSpeed'].toString()) ?? 0.0
          : 0.0,
      description: map['description'] ??
          '', // Default to empty string if description is null
      activities:
          map['activities'] != null ? List<String>.from(map['activities']) : [],
      rating: map['rating'] != null
          ? double.tryParse(map['rating'].toString()) ?? 0.0
          : 0.0,
    );
  }
}

// Water Quality Algorithm
class SuitabilityAlgorithm {
  static String evaluateWaterQuality(Map<String, dynamic> weatherData) {
    double waveHeight =
        (weatherData['current']['wave_height'] ?? 0.0).toDouble();
    double windSpeed = (weatherData['current']['wind_speed'] ?? 0.0).toDouble();

    if (waveHeight > 2.5 || windSpeed > 30) {
      return 'Poor'; // Unsafe for swimming
    } else if (waveHeight > 1.5 || windSpeed > 20) {
      return 'Moderate'; // Caution advised
    }
    return 'Good'; // Safe for swimming
  }
}
