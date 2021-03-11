import 'package:flutter/material.dart';

typedef Widget CityItemWidgetBuilder(BuildContext context);

/// Called to build IndexBar.
typedef Widget IndexBarBuilder(BuildContext context, List<String> tags);

/// Called to build index hint.
typedef Widget IndexHintBuilder(BuildContext context, String hint);
