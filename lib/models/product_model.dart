class Product {
  final String id;
  final String deviceCondition;
  final String listedBy;
  final String deviceStorage;
  final String imageUrl;
  final int price;
  final String location;
  final String make;
  final String marketingName;
  final String model;

  Product({
    required this.id,
    required this.deviceCondition,
    required this.listedBy,
    required this.deviceStorage,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.make,
    required this.marketingName,
    required this.model,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>;
    final defaultImage = json['defaultImage'];

    return Product(
      id: json['_id'],
      deviceCondition: json['deviceCondition'],
      listedBy: json['listingDate'],
      deviceStorage: json['deviceStorage'],
      imageUrl: images.isNotEmpty
          ? images[0]['fullImage']
          : defaultImage['fullImage'],
      price: json['listingNumPrice'],
      location: json['listingLocation'],
      make: json['make'],
      marketingName: json['model'],
      model: json['model'],
    );
  }
}