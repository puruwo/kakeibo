// packageImport
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// LocalImport
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/model/db_read.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/repository/tbl201_record/tbl201_record.dart';
import 'package:kakeibo/repository/tbl202_record/tbl202_record.dart';

import 'package:kakeibo/view_model/provider/small_category_edit_page/small_category_edit_mode.dart';
import 'package:kakeibo/view_model/provider/update_DB_count.dart';

class SmallCategoryEditPage extends ConsumerStatefulWidget {
  const SmallCategoryEditPage({super.key, required this.bigCategoryId});
  final int bigCategoryId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SmallCategoryEditPageState();
}

class _SmallCategoryEditPageState extends ConsumerState<SmallCategoryEditPage> {
  // そのカテゴリーのproperty
  Map<String, dynamic>? bigCategoryProperty;

  // そのカテゴリーの情報
  List<Map<String, dynamic>>? categoryData;

  // 小カテゴリーの情報リスト
  final List<ListItem> itemList = [];

  // 編集モードで編集されたかどうか
  bool isEdited = false;

  TBL202Record? tbl202record;

  @override
  void initState() {
    // 初期化が終わる前にbuildが完了してしまうのでawait&SetStateする
    Future(() async {
      await initialize();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editmodeProvider = ref.watch(smallCategoryEditModeNotifierProvider);

    return Scaffold(
        // ヘッダー
        appBar: AppBar(
          //ヘッダー右のアイコンボタン
          actions: [
            IconButton(
              icon: editmodeProvider
                  ? const Icon(
                      //完了チェックマーク
                      Icons.done_rounded,
                      color: MyColors.white,
                    )
                  : const Text('編集'),
              onPressed: () {
                // 登録処理
                editmodeProvider ? registorFunction() : null;

                //DB更新のnotifier
                //DBが更新されたことをグローバルなproviderに反映
                editmodeProvider ? dbUpdateNotify() : null;

                // 編集モードの状態を更新
                final notifier =
                    ref.read(smallCategoryEditModeNotifierProvider.notifier);
                notifier.updateState();
                // 編集したかどうかを初期化
                isEdited = false;
              },
            ),
          ],
        ),

        // 本体
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 大カテゴリーの設定ボックス
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: MyColors.quarternarySystemfill,
                    borderRadius: BorderRadius.circular(18)),
                height: 135,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // アイコン部分
                    GestureDetector(
                      onTap: () {
                        print('icon parts is tapped!');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // カテゴリーアイコン
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0,left: 18),
                            child: Container(
                              width: 45,
                              height: 45,
                              color: MyColors.black,
                            ),
                          ),
                          // 編集マーク
                          Container(
                              width: 18,
                              height: 18,
                              color: MyColors.black,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // カテゴリー名入力部分
                    Text(tbl202record!.bigCategoryName),
                  ],
                ),
              ),
            ),

            // 小カテゴリーのリスト
            Expanded(
              child: editmodeProvider == true
                  ? ReorderableListView.builder(
                      // 並べ替えた時の処理
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          reorderFunction(oldIndex, newIndex);
                          // 変更を加えたことを管理する状態管理する
                        });
                      },
                      itemCount: categoryData!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          key: Key('$index'),
                          children: [
                            // チェックボックス
                            ElevatedButton(
                                onPressed: () {
                                  // チェックボックスのタップ処理
                                  setState(() {
                                    final bool = itemList[index].isChecked;
                                    // チェックボックスに渡す値を更新する
                                    itemList[index].isChecked = !bool;
                                    // 編集済みフラグを立てる
                                    isEdited = true;
                                  });
                                },
                                child: itemList[index].isChecked
                                    ? Container(
                                        height: 20,
                                        width: 10,
                                        color: MyColors.blue,
                                      )
                                    : Container(
                                        height: 20,
                                        width: 10,
                                      )),

                            Text(
                              itemList[index].bigCategoryKey.toString(),
                              style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  color: MyColors.label,
                                  fontWeight: FontWeight.w400),
                            ),
                            const Text(' '),
                            Text(
                              itemList[index].bigCategoryOrderInBig.toString(),
                              style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  color: MyColors.label,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              itemList[index].editedDisplayOrder.toString(),
                              style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  color: MyColors.label,
                                  fontWeight: FontWeight.w400),
                            ),
                            const Text(' '),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: itemList[index].controller,
                                // テキストフィールドのプロパティ
                                textAlign: TextAlign.right,
                                textAlignVertical: TextAlignVertical.top,
                                style: const TextStyle(
                                    color: MyColors.white, fontSize: 17),

                                // 編集されたら編集フラグをtrueに
                                onChanged: (value) {
                                  isEdited = true;
                                },

                                // //領域外をタップでproviderを更新する
                                onTapOutside: (event) {
                                  //キーボードを閉じる
                                  FocusScope.of(context).unfocus();
                                },
                                onEditingComplete: () {
                                  //キーボードを閉じる
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  // 非編集時
                  : ListView.builder(
                      itemCount: categoryData!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Row(
                            key: Key('$index'),
                            children: [
                              Text(
                                itemList[index].bigCategoryKey.toString(),
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: MyColors.label,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Text(' '),
                              Text(
                                itemList[index]
                                    .bigCategoryOrderInBig
                                    .toString(),
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: MyColors.label,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                itemList[index].editedDisplayOrder.toString(),
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: MyColors.label,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                itemList[index].controller.text,
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: MyColors.label,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ));
  }

  initialize() async {
    // DBから取得
    // {
    //  id:
    //  small_category_order_key
    //  big_category_key
    //  displayed_order_in_big
    //  category_name
    //  default_displayed
    // }
    bigCategoryProperty = await getBigCategoryProperty(widget.bigCategoryId);

    // DBから取得
    // {
    //  id:
    //  small_category_order_key
    //  big_category_key
    //  displayed_order_in_big
    //  category_name
    //  default_displayed
    // }
    categoryData = await getCategoryDataFromCategoryId(widget.bigCategoryId);

    // インスタンス化
    tbl202record = TBL202Record(
        id: bigCategoryProperty![TBL202RecordKey().id],
        colorCode: bigCategoryProperty![TBL202RecordKey().colorCode],
        bigCategoryName:
            bigCategoryProperty![TBL202RecordKey().bigCategoryName],
        resourcePath: bigCategoryProperty![TBL202RecordKey().resourcePath],
        displayOrder: bigCategoryProperty![TBL202RecordKey().displayOrder],
        isDisplayed: bigCategoryProperty![TBL202RecordKey().isDisplayed]);

    // itemListの初期化
    for (int i = 0; i < categoryData!.length; i++) {
      itemList.add(ListItem(
        id: categoryData![i][TBL201RecordKey().id],
        smallCategoryOrderKey: categoryData![i]
            [TBL201RecordKey().smallCategoryOrderKey],
        bigCategoryKey: categoryData![i][TBL201RecordKey().bigCategoryKey],
        bigCategoryOrderInBig: categoryData![i]
            [TBL201RecordKey().displayedOrderInBig],
        categoryName: categoryData![i][TBL201RecordKey().categoryName],
        defaultDisplayed: categoryData![i][TBL201RecordKey().defaultDisplayed],
      ));
    }
  }

  void reorderFunction(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = itemList.removeAt(oldIndex);
    itemList.insert(newIndex, item);

    // itemの表示順を更新
    //
    for (int i = 0; i < itemList.length; i++) {
      itemList[i].editedDisplayOrder = i;
    }
  }

  void doneSnackBarFunc() {
    // Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('登録が完了しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
  }

  registorFunction() {
    for (int i = 0; i < itemList.length; i++) {
      // 最初に取得した値段と入力した値段が違っており更新されれば挿入する
      if (isEdited) {
        final int id = itemList[i].id;
        final int smallCategoryOrderKey = itemList[i].smallCategoryOrderKey;
        final int bigCategoryKey = itemList[i].bigCategoryKey;
        final int displayOrderInBig = itemList[i].editedDisplayOrder;
        final String categoryName = itemList[i].controller.text;
        final int defaultDisplayed = itemList[i].isChecked == true ? 1 : 0;

        // 目標データのインスタンス化
        final record = TBL201Record(
            id: id,
            smallCategoryOrderKey: smallCategoryOrderKey,
            bigCategoryKey: bigCategoryKey,
            displayedOrderInBig: displayOrderInBig,
            categoryName: categoryName,
            defaultDisplayed: defaultDisplayed);

        // 目標データの挿入
        record.update();

        // スナックバーの表示
        doneSnackBarFunc();
      }
    }
  }

  dbUpdateNotify() {
    final notifier = ref.read(updateDBCountNotifierProvider.notifier);
    notifier.incrementState();
  }
}

class ListItem {
  // カテゴリーのIDを取得
  final int id;
  // 登録画面でのカテゴリーの並び順
  final int smallCategoryOrderKey;
  // 所属する大カテゴリー
  final int bigCategoryKey;
  // DBから取得した大カテゴリー内の表示順
  final int bigCategoryOrderInBig;
  // 編集後表示順
  late int editedDisplayOrder;
  // カテゴリーの名前を取得
  final String categoryName;
  // DBでの表示非表示設定 0 or 1
  final int defaultDisplayed;
  // 表示非表示の設定
  late bool isChecked;
  // 小カテゴリー名のコントローラー
  late TextEditingController controller;

  ListItem({
    required this.id,
    required this.smallCategoryOrderKey,
    required this.bigCategoryKey,
    required this.bigCategoryOrderInBig,
    required this.categoryName,
    required this.defaultDisplayed,
  }) {
    // 表示日表示の初期化
    isChecked = defaultDisplayed == 1 ? true : false;
    // 編集後表示順の初期化
    editedDisplayOrder = bigCategoryOrderInBig;
    // 小カテゴリー名のコントローラーの初期化
    controller = TextEditingController(text: categoryName);
  }
}
