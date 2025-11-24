class District {
  final String name;
  final String code;
  final List<City> cities;

  District({
    required this.name,
    required this.code,
    required this.cities,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      cities: (json['cities'] as List<dynamic>?)
              ?.map((city) => City.fromJson(city as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'cities': cities.map((city) => city.toJson()).toList(),
    };
  }
}

class City {
  final String name;
  final String code;

  City({
    required this.name,
    required this.code,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}
