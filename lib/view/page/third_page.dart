/// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakeibo/util/util.dart';
import 'package:kakeibo/view/atom/previous_arrow_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';

/// Local imports
import 'package:kakeibo/view/organism/category_sum_tile.dart';
import 'package:kakeibo/view/organism/balance_graph.dart';
import 'package:kakeibo/view/organism/balance_graph_syncfusion.dart';
import 'package:kakeibo/view/organism/prediction_graph.dart';
import 'package:kakeibo/view/organism/all_category_sum_tile.dart';

import 'package:kakeibo/view/molecule/calendar_month_display.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/view_model/category_sum_getter.dart';

import 'package:kakeibo/view/page/budget_setting_page.dart';

class Third extends ConsumerStatefulWidget {
  const Third({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThirdState();
}

class _ThirdState extends ConsumerState<Third> {
  @override
  Widget build(BuildContext context) {
    //状態管理---------------------------------------------------------------------------------------

    // DBが更新されたらリビルドするため
    ref.watch(updateDBCountNotifierProvider);

    final provider = ref.watch(activeDatetimeNotifierProvider);

    //----------------------------------------------------------------------------------------------
    //データ取得--------------------------------------------------------------------------------------

    Future<List<Map<String, dynamic>>> bigcategorySumMapList =
        BigCategorySumMapGetter().build(provider);
    // {
    // _id:
    // color_code:
    // big_category_name:
    // resource_path:
    // big_category_budget:
    // payment_price_sum:
    // smallCategorySumAndBudgetList:{_id
    //                                small_category_payment_sum :
    //                                big_category_key:
    //                                tdisplayed_order_in_big:
    //                                category_name:
    //                                default_displayed}:
    // }

    Future<List<Map<String, dynamic>>> paymentSumByBig =
        AllPaymentGetter().build(provider);

    Future<List<Map<String, dynamic>>> allBudgetSum =
        AllBudgetGetter().build(provider);

    //--------------------------------------------------------------------------------------------
    //レイアウト------------------------------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: SizedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // //左矢印ボタン、押すと前の月に移動
                // PreviousArrowButton(function: () async {
                //   await pageController.previousPage(
                //       duration: const Duration(milliseconds: 200),
                //       curve: Curves.easeOutCubic);
                // }),
                Consumer(builder: (context, ref, _) {
                  final activeDt = ref.watch(activeDatetimeNotifierProvider);
                  final label = labelGetter(activeDt);
                  return CalendarMonthDisplay(label: label);
                }),
                // NextArrowButton(function: () async {
                //   await pageController.nextPage(
                //       duration: const Duration(milliseconds: 200),
                //       curve: Curves.easeOutCubic);
                // }),
              ]),
        ),
      ),
      backgroundColor: MyColors.secondarySystemBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 0,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' 今月の支出と目標',
                      style: GoogleFonts.notoSans(
                          fontSize: 18,
                          color: MyColors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            //sccafoldの上に出すか
                            useRootNavigator: true,
                            //縁タップで閉じる
                            isDismissible: true,
                            context: context,
                            // constで呼び出さないとリビルドがかかってtextfieldのも何度も作り直してしまう
                            builder:(context) => Navigator(
                              onGenerateRoute: (context) =>
                                  MaterialPageRoute<BudgetSettingPage>(
                                builder: (context) => const BudgetSettingPage(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          '予算設定',
                          style: TextStyle(color: MyColors.linkColor),
                        )),
                  ],
                ),
              ),

              // グラフ部分
              FutureBuilder(
                  future: allBudgetSum,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      // constで呼び出さないとリビルドがかかってグラフの挙動がおかしくなる
                      return const PredictionGraph();
                    } else {
                      return Container();
                    }
                  })),

              // カテゴリータイル
              FutureBuilder(
                  future: Future.wait(
                      [bigcategorySumMapList, paymentSumByBig, allBudgetSum]),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('エラーが発生しました');
                    } else {
                      // 全カテゴリーのタイル
                      return AllCategorySumTile(
                          // ['big_category_name'] ['payment_price_sum'] ['icon'] ['color']
                          bigCategoryInformationMaps: snapshot.data![0],
                          // int
                          allCategorySum: snapshot.data![1][0]['all_price_sum'],
                          // int
                          allCategoryBudgetSum: snapshot.data![2][0]
                              ['budget_sum']);
                    }
                  })),
              FutureBuilder(
                  future: bigcategorySumMapList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children:
                              List.generate(snapshot.data!.length, (index) {
                        // 個別カテゴリーのタイル
                        return CategorySumTile(
                            icon: CategoryHandler().iconGetterFromPath(snapshot
                                .data![index][TBL202RecordKey().resourcePath]),
                            categoryName: snapshot.data![index]
                                [TBL202RecordKey().bigCategoryName],
                            colorCode: snapshot.data![index]
                                [TBL202RecordKey().colorCode],
                            bigCategorySum: snapshot.data![index]
                                ['payment_price_sum'],
                            budget: snapshot.data![index]
                                ['big_category_budget'],
                            smallCategorySumList: snapshot.data![index]
                                ['smallCategorySumAndBudgetList']);
                      }));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
