import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';

import 'package:kakeibo/view/organism/category_sum_tile.dart';
import 'package:kakeibo/view/organism/balance_graph.dart';
import 'package:kakeibo/view/organism/all_category_sum_tile.dart';

import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/category_sum_getter.dart';

import 'package:kakeibo/model/tbl_impl.dart';

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

    Future<List<Map<String, dynamic>>> allBigCategoryInformationMapList =
        AllBigCategoryInformationMapListGetter().build(provider);
    Future<List<Map<String, dynamic>>> priceSum =
        AllPriceGetter().build(provider);
    Future<List<Map<String, dynamic>>> budgetSum =
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LineChartSample(),
              FutureBuilder(
                  future: Future.wait(
                      [allBigCategoryInformationMapList, priceSum, budgetSum]),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('エラーが発生しました');
                    } else {
                      return AllCategorySumTile(bigCategoryInformationMaps: snapshot.data![0], allCategorySum: snapshot.data![1][0]['all_price_sum'], allCategoryBudgetSum: snapshot.data![2][0]['budget_sum']);
                      
                    }
                  })),
              FutureBuilder(
                  future: bigcategorySumMapList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children:
                              List.generate(snapshot.data!.length, (index) {
                        return CategorySumTile(
                            icon: CategoryHandler().iconGetterFromPath(snapshot
                                .data![index][TBL202RecordKey().resourcePath]),
                            categoryName: snapshot.data![index]
                                [TBL202RecordKey().bigCategoryName],
                            bigCategorySum: snapshot.data![index]['sum_price'],
                            budget: snapshot.data![index]['budget'],
                            smallCategorySumList: snapshot.data![index]
                                ['smallCategoryMaps']);
                      }));
                    } else {
                      return Text('loading now');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
