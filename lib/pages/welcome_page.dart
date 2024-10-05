import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/style/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: <Color>[
              FatGPTColors.accentDark1,
              FatGPTColors.accentDark2,
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image(image: AssetImage('images/logo.png')),
                Container(
                  // decoration: BoxDecoration(
                  //   color: FatGPTColors.cardBackground,
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'FatGPT',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            'Generate meal ideas with fridge photo',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 64,
                ),
                Spacer(),
                ElevatedButton(
                  child: Text("Get started"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FatGPTColors.accent,
                    minimumSize: Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
