import 'package:flutter/material.dart';

// Removing the blue shadow when scrolling in Column/ListView.
class My_Behavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
