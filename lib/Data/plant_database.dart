class Plant {
  final int id;
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final String description;

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.imageUrl,
    required this.description,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      commonName: json['common_name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

