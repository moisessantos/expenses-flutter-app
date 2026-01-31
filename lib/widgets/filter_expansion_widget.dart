import 'package:flutter/material.dart';
import 'package:expenses_app/constants.dart';

class FilterExpansionWidget extends StatelessWidget {
  final String title;
  final bool loading;
  final Widget child;
  final bool initiallyExpanded;

  const FilterExpansionWidget({
    super.key,
    required this.title,
    required this.loading,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: ExpansionTile(
        title: Text(title),
        initiallyExpanded: initiallyExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kPadding8),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(kPadding8),
                    child: CircularProgressIndicator(),
                  )
                : child,
          ),
        ],
      ),
    );
  }
}
