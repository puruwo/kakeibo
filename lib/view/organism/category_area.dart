import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kakeibo/view/molecule/icon_button.dart';

import 'package:kakeibo/view_model/provider/torok_state/torok_state.dart';

import 'package:kakeibo/model/tbl_impl.dart';

class CategoryArea extends ConsumerStatefulWidget {
  const CategoryArea({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryAreaState();
}

class _CategoryAreaState extends ConsumerState<CategoryArea> {
  final pageController = PageController(initialPage: 0);
  Future<int> pageNumber = Future(() => 0);
  Future<int> displayCategoryNumber = Future(() => 0);

  @override
  void initState() {
    super.initState();
    //データ取得---------------------------------------------------------------------------------------

    // 表示するページ数
    pageNumber = Future(() async {
      // 表示するカテゴリー数
      final displayCategoryNumber = await getDisplayCategoryNumber();
      // 小数点切り上げ
      return (displayCategoryNumber / 15).ceil();
    });

    // 表示するカテゴリー数
    displayCategoryNumber = getDisplayCategoryNumber();

    //----------------------------------------------------------------------------------------------
  }

  @override
  Widget build(context) {
//状態管理---------------------------------------------------------------------------------------

    final activeButtonNumberProvider = ref
        .watch(torokRecordNotifierProvider.select((record) => record.category));

    final activeButtonNumberNotifier =
        ref.watch(torokRecordNotifierProvider.notifier);

//----------------------------------------------------------------------------------------------

    return FutureBuilder(
      future: Future.wait([pageNumber,displayCategoryNumber]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

        return SizedBox(
          height: 200,
          width: 350,
          child: PageView.builder(
            controller: pageController,
            itemCount: snapshot.data![0],
            itemBuilder: (context, pageIndex) {
              
              final displayCategoryNumber = snapshot.data![1];

              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3, //3行の意味
                    (columnIndex) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //indexの実装
                        children: List.generate(
                          5, //1列5個の意味

                          (rowIndex) {
                            //ボタンの番号
                            final buttonNumber =
                                pageIndex * 15 + columnIndex * 5 + rowIndex;
                            //ボタン番号とrecordが持つボタン番号が一致しているかの判定をする、選択状態かどうかを決める
                            final isSelected =
                                (buttonNumber == activeButtonNumberProvider);

                            // ボタンのkey
                            // 表示するカテゴリー数(displayCategoryNumber)より小さければそのbuttonNumberを代入
                            // カテゴリー数より大きければ-1を代入(表示しない)
                            final buttonInfo =
                                buttonNumber + 1 <= displayCategoryNumber
                                    ? buttonNumber
                                    : -1;

                            return GestureDetector(
                              onTap: buttonInfo != -1
                                  ? () {
                                      //状態の更新
                                      activeButtonNumberNotifier
                                          .updateCategory(buttonNumber);
                                    }
                                  : () {
                                      // 何もしない
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: CategoryIconButton(
                                  //nullチェックどうするか考え直す
                                  buttonInfo: buttonInfo,
                                  isSelected: isSelected,
                                ),
                              ),
                            );
                          },
                        )),
                  ));
            },
          ),
        );
      },
    );
  }
}
