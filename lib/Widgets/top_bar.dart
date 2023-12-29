import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String barTitle;
  Widget? primaryAction;
  Widget? secondAction;
  double? fontSize;

  late double deviceHeight;
  late double deviceWidth;

  TopBar(this.barTitle,
      {super.key, this.primaryAction, this.secondAction, this.fontSize = 35});

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return buildUI();
  }

  Widget buildUI() {
    return Container(
      height: deviceHeight * 0.1,
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondAction != null) secondAction!,
          titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget titleBar() {
    return Text(
      barTitle,
      overflow: TextOverflow.clip,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
