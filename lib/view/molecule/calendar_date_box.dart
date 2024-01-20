import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';

Container vacantDateBox(int weekday, String dateLabel, String? expenceLabel) {
  return Container(
    width: 50,
    height: 46,
    decoration: BoxDecoration(
        border: Border.all(color: MyColors.lightGray), color: Colors.black),
    child: Center(
      child: Column(
        children: [
          Text(dateLabel),
          Text(
            expenceLabel ??= '',
          )
        ],
      ),
    ),
  );
}

Container normalDateBox(int weekday, String dateLabel, String? expenceLabel) {
  return Container(
    width: 50,
    height: 46,
    decoration: BoxDecoration(
        border: Border.all(color: MyColors.richBlack, width: 1),
        color: MyColors.richBlack),
    child: Center(
      child: Column(
        children: [
          Text(
            dateLabel,
            style: TextStyle(
              color: weekday == 7
                  ? MyColors.blue
                  : weekday == 1
                      ? MyColors.red
                      : MyColors.white,
            ),
          ),
          Text(
            expenceLabel ??= '',
            style: const TextStyle(color: MyColors.white),
          )
        ],
      ),
    ),
  );
}

Container activeDateBox(int weekday, String dateLabel, String? expenceLabel) {
  return Container(
    width: 50,
    height: 46,
    decoration: BoxDecoration(
        border: Border.all(color: MyColors.richBlack, width: 1),
        color: MyColors.jet),
    child: Center(
      child: Column(
        children: [
          Text(
            dateLabel,
            style: TextStyle(
              color: weekday == 7
                  ? MyColors.blue
                  : weekday == 1
                      ? MyColors.red
                      : MyColors.white,
            ),
          ),
          Text(
            expenceLabel ??= '',
            style: TextStyle(color: MyColors.white),
          )
        ],
      ),
    ),
  );
}
