import 'package:flutter/material.dart';

class PrimaryColorDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.primary,
      thickness: 2.0, // Adjust thickness as needed
    );
  }
}
