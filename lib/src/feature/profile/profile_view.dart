import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with AdaptivePage {
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
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile View")),
    );
  }
}
