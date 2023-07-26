import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              AspectRatio(
                aspectRatio:
                1.5, // Adjust the aspectRatio as needed for image height
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.marketingName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Storage: ${product.deviceStorage}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Condition: ${product.deviceCondition}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Location: ${product.location}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Date: ${product.listedBy}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}