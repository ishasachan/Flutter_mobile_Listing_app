class Filter {
  final List<String> make;
  final List<String> condition;
  final List<String> storage;
  final List<String> ram;
  List<String> warranty;
  List<String> verification;
  int? minPrice;
  int? maxPrice;

  Filter({
    required this.make,
    required this.condition,
    required this.storage,
    required this.ram,
    required this.warranty,
    required this.verification,
    this.minPrice,
    this.maxPrice,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      make: _getListFromJson(json, 'make'),
      condition: _getListFromJson(json, 'condition'),
      storage: _getListFromJson(json, 'storage'),
      ram: _getListFromJson(json, 'ram'),
      warranty: ['All'], // Default to 'All'
      verification: ['All'], // Default to 'All'
    );
  }

  static List<String> _getListFromJson(Map<String, dynamic> json, String key) {
    final list = json[key] as List<dynamic>;
    final withAll = ['All', ...list.map((item) => item.toString())];
    return withAll.cast<String>();
  }

  void updateWarranty(List<String> warrantyOptions) {
    warranty.clear();
    warranty.addAll(['All', ...warrantyOptions]);
  }

  void updateVerification(List<String> verificationOptions) {
    verification.clear();
    verification.addAll(['All', ...verificationOptions]);
  }

  void updatePriceRange(int minPrice, int maxPrice) {
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
  }
}