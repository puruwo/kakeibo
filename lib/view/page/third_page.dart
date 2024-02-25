import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';

import 'package:kakeibo/view/test_all_row_get_button.dart';
import 'package:kakeibo/view/organism/price_input_field.dart';
import 'package:kakeibo/view/organism/memo_input_field.dart';
import 'package:kakeibo/view/organism/category_area.dart';
import 'package:kakeibo/view/organism/date_input_field.dart';
import 'package:kakeibo/view/organism/category_sum_tile.dart';
import 'package:kakeibo/view/organism/balance_graph.dart';

import 'package:kakeibo/view_model/provider/tbl001_state/tbl001_state.dart';
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

    //listenもしくはwatchし続けやんとstateが勝手にdisposeされる
    //なのでlistenしている
    //watchやといちいちリビルドされるのでlisten
    ref.listen(
      tBL001RecordNotifierProvider,
      (oldState, newState) {
        //なんもしやん
      },
    );

    final provider = ref.watch(activeDatetimeNotifierProvider);

    //----------------------------------------------------------------------------------------------
    //データ取得--------------------------------------------------------------------------------------
    Future<List<Map<String, dynamic>>> bigcategorySumMapList =
        BigCategorySumMapGetter().build(provider);

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
                  future: bigcategorySumMapList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: List.generate(snapshot.data!.length, (index) {
                        return CategorySumTile(
                            icon: CategoryHandler().iconGetterFromPath(snapshot
                                .data![index][TBL004RecordKey().resourcePath]),
                            categoryName: snapshot.data![index]
                                [TBL004RecordKey().bigCategoryName],
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
