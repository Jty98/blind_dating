import 'package:blind_dating/view/appbarWidget.dart';
import 'package:blind_dating/components/paymentsWidget.dart';
import 'package:flutter/material.dart';

class PayMentsPage extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme;
  const PayMentsPage({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PayMentsWidget(onChangeTheme: onChangeTheme),
            ],
          ),
        ),
      ),
    );
  }
}
