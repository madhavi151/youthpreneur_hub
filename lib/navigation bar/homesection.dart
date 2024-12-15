import 'package:Youthpreneur_Hub/screens/service_screen.dart';
import 'package:flutter/material.dart';

import '../screens/businesspage.dart';

class HomeSectionPage extends StatelessWidget {
  const HomeSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // BusinessScreen takes up available space but not necessarily scrollable
        Flexible(
          flex: 1,
          child: BusinessScreen(),
        ),
      ],
    );
  }
}
