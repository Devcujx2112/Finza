import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:flutter/material.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> with AdaptivePage {
  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    throw UnimplementedError();
  }

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) {
    return mobileScreen(context);
  }

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) {
    // TODO: implement tabletLandscapeBody
    throw UnimplementedError();
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    // TODO: implement tabletPortraitBody
    throw UnimplementedError();
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget")),
      body: const Center(child: Text("Budget View")),
    );
  }
}
