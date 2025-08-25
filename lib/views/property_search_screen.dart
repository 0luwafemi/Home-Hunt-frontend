import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_dto.dart';
import '../models/property_search_criteria.dart';

import '../property_card.dart';
import '../providers/property_search_provider.dart';
 // Your existing card widget

class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  State<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends State<PropertySearchScreen> {
  final _formKey = GlobalKey<FormState>();
  String location = '';
  PropertyType? type;
  PropertyStatus? status;
  double minPrice = 100000;
  double maxPrice = 1000000;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertySearchProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Find Your Property')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    onChanged: (value) => location = value,
                  ),
                  DropdownButtonFormField<PropertyType>(
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: PropertyType.values.map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name),
                    )).toList(),
                    onChanged: (value) => type = value,
                  ),
                  DropdownButtonFormField<PropertyStatus>(
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: PropertyStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name),
                    )).toList(),
                    onChanged: (value) => status = value,
                  ),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 50000,
                    max: 5000000,
                    divisions: 50,
                    labels: RangeLabels('₦${minPrice.toInt()}', '₦${maxPrice.toInt()}'),
                    onChanged: (range) {
                      setState(() {
                        minPrice = range.start;
                        maxPrice = range.end;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (type != null && status != null) {
                        final criteria = PropertySearchCriteria(
                          location: location,
                          type: type!,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          status: status!,
                        );
                        provider.clear();
                        provider.search(criteria);
                      }
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(child: Text('Error: ${provider.error}'))
                  : ListView.builder(
                itemCount: provider.results.length,
                itemBuilder: (context, index) {
                  final property = provider.results[index];
                  return PropertyCard(property: property);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/property_dto.dart';
// import '../models/property_search_criteria.dart';
// import '../providers/property_search_provider.dart';
//
// class PropertySearchScreen extends StatelessWidget {
//   const PropertySearchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<PropertySearchProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Property Search')),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               final criteria = PropertySearchCriteria(
//                 location: 'Abuja',
//                 type: PropertyType.House,
//                 minPrice: 100000.0,
//                 maxPrice: 500000.0,
//                 status: PropertyStatus.AVAILABLE,
//               );
//               provider.search(criteria);
//             },
//             child: const Text('Search Properties'),
//           ),
//           Expanded(
//             child: provider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : provider.error != null
//                 ? Center(child: Text('Error: ${provider.error}'))
//                 : ListView.builder(
//               itemCount: provider.results.length,
//               itemBuilder: (context, index) {
//                 final property = provider.results[index];
//                 return ListTile(
//                   title: Text(property.title),
//                   subtitle: Text('${property.location} • ₦${property.price.toStringAsFixed(0)}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
