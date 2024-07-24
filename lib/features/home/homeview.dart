import 'package:flutter/material.dart';
import 'package:musicapp/utilits/assets.dart';
import 'package:musicapp/utilits/constants/constant.dart';
import 'package:musicapp/utilits/constants/fontsStyles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      title: Image.asset(
        AssetsConstant.Splashlogo,
        height: 50,
      ),
      leading: const Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.logout_rounded),
      ),
    ));
  }
}
