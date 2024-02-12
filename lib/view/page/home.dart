import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view/organism/calendar_area.dart';
import 'package:kakeibo/view/organism/expence_history_list_area.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.jet,
        title: const SizedBox(
          child: Text('Home'),
        ),
      ),
      backgroundColor: MyColors.eerieBlack,
      body: const Center(
        child: Column(children: [
          CalendarArea(),
          ExpenceHistoryArea(),
        ]),
      ),
    );
  }
}