import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hurriyat_radio/config/config.dart';
import 'package:hurriyat_radio/pages/intro.dart';
import 'package:hurriyat_radio/utils/next_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000))
        .then((value) => nextScreenCloseOthers(context, IntroPage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Lottie.asset(
          Config().doneAsset,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: 200,
          width: 200,
          repeat: false,
        ),
      ),
    );
  }
}
