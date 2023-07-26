import 'package:flutter/material.dart';

import '../models/filter_model.dart';

class FilterMenu extends StatefulWidget {
  final Filter filters;
  final void Function(String)? onMakeSelected;
  final void Function(String)? onConditionSelected;
  final void Function(String)? onRamSelected;
  final void Function(String)? onStorageSelected;

  const FilterMenu({
    Key? key,
    required this.filters,
    this.onMakeSelected,
    this.onConditionSelected,
    this.onRamSelected,
    this.onStorageSelected,
  }) : super(key: key);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  // final List<String> _warrantyOptions = ['Brand Warranty', 'Seller Warranty', 'All'];
  // final List<String> _verificationOptions = ['All', 'Verified'];
  //
  // void _handleWarrantySelected(String option) {
  //   setState(() {
  //     widget.filters.updateWarranty([option]);
  //   });
  // }
  //
  // void _handleVerificationSelected(String option) {
  //   setState(() {
  //     widget.filters.updateVerification([option]);
  //   });
  // }

  RangeValues _priceRange = const RangeValues(0, 40000); // Default price range values

  void _handlePriceRangeChanged(RangeValues values) {
    setState(() {
      _priceRange = values;
      widget.filters.updatePriceRange(values.start.round(), values.end.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        color: Colors.white, // Add your desired background color here
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filters",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      "Clear Filters",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              _buildFilterSection(
                  'Brand', widget.filters.make, widget.onMakeSelected),
              _buildFilterSection(
                  'Ram', widget.filters.ram, widget.onRamSelected),
              _buildFilterSection(
                  'Storage', widget.filters.storage, widget.onStorageSelected),
              _buildFilterSection('Conditions', widget.filters.condition,
                  widget.onConditionSelected),
              // _buildFilterSection('Warranty', widget.filters.warranty, _handleWarrantySelected),
              // _buildFilterSection('Verification', widget.filters.verification, _handleVerificationSelected),
              _buildPriceRangeSlider(),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    // width: double.infinity,
                      alignment: Alignment.center,
                      color: const Color.fromARGB(255, 44, 46, 66),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Apply",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String>? options,
      void Function(String)? onOptionSelected) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (options != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options
                    .map((option) => GestureDetector(
                  onTap: () {
                    onOptionSelected?.call(option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(option),
                  ),
                ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 40000,
            divisions: 4000,
            labels: RangeLabels(_priceRange.start.toString(), _priceRange.end.toString()),
            onChanged: _handlePriceRangeChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ₹${_priceRange.start.round()}'),
              Text('Max: ₹${_priceRange.end.round()}'),
            ],
          ),
        ],
      ),
    );
  }
}
