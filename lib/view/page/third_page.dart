/// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

import 'package:kakeibo/view_model/provider/active_datetime.dart';
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
        backgroundColor: MyColors.jet,
        title: const SizedBox(
          child: Text('kakeibo'),
        ),
      ),
      // backgroundColor: MyColors.secondarySystemBackground,
      backgroundColor: MyColors.secondarySystemBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 16,),

              Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                child: Row(children: [Text(' 今月の支出と目標',style: GoogleFonts.notoSans(
                                    fontSize: 18,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w400),),],),
              ),

              const SizedBox(height: 8,),
              
              // TextButton(onPressed: (){showCupertinoModalBottomSheet(
              //                           //sccafoldの上に出すか
              //                           useRootNavigator: true,
              //                           //縁タップで閉じる
              //                           isDismissible: true,
              //                           context: context,
              //                           builder: (_) => BedgetSettingPage(),
              //                         );}, child: const Text('予算設定')),

              // グラフ部分
              FutureBuilder(
                  future: allBudgetSum,
                  builder: ((context, snapshot) {
                    if(snapshot.hasData){
                    return PredictionGraph(
                      allBudgetSum: snapshot.data![0]
                              ['budget_sum'] as int,
                    );}else{
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
