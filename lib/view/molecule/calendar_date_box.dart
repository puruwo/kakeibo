import 'package:flutter/material.dart';

import 'package:kakeibo/constant/colors.dart';

double width = 46.0;

Container vacantDateBox(int weekday, String dateLabel, String? expenceLabel,double boxHeight) {
  return Container(
    width: width,
    height: boxHeight,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),),
    child: Center(
      child: Column(
        children: [
          Text(dateLabel,style: const TextStyle(color: MyColors.tirtiaryLabel)),
        ],
      ),
    ),
  );
}

Container normalDateBox(int weekday, String dateLabel, String? expenceLabel,double boxHeight) {
  return Container(
    width: width,
    height: boxHeight,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),),
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
                      : MyColors.secondaryLabel,
            ),
          ),
          Text(
            expenceLabel ??= '',
            style: const TextStyle(color: MyColors.white,fontSize: 11),
          )
        ],
      ),
    ),
  );
}

Container activeDateBox(int weekday, String dateLabel, String? expenceLabel,double boxHeight) {
  return Container(
    width: width,
    height: boxHeight,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: MyColors.tirtiarySystemfill),
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
                      : MyColors.secondaryLabel,
            ),
          ),
          Text(
            expenceLabel ??= '',
            style: const TextStyle(color: MyColors.white,fontSize: 11),
          )
        ],
      ),
    ),
  );
}
