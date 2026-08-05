import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> with AdaptivePage {
  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    // TODO: implement mobileLandscapeBody
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
      appBar: AppBar(title: const Text("Schedule")),
      body: const Center(child: Text("Schedule View")),
    );
  }
}
