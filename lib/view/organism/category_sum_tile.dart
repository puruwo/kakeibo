import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/util/util.dart';
import 'package:kakeibo/util/screen_size_func.dart';

import 'package:kakeibo/model/assets_conecter/category_handler.dart';
import 'package:kakeibo/model/tableNameKey.dart';
import 'package:kakeibo/view_model/category_sum_getter.dart';

class CategorySumTile extends StatefulWidget {
  const CategorySumTile(
      {required this.icon,
      required this.categoryName,
      required this.colorCode,
      required this.bigCategorySum,
      required this.budget,
      required this.smallCategorySumList,
      super.key});

  final Widget icon;
  final String categoryName;
  final String colorCode;
  final int bigCategorySum;
  final int budget;
  final List<Map<String, dynamic>> smallCategorySumList;

  final double barFrameWidth = 280.0;

  @override
  State<CategorySumTile> createState() => _CategorySumTileState();
}

class _CategorySumTileState extends State<CategorySumTile>
    with SingleTickerProviderStateMixin {
  //横棒グラフの初期値
  double barWidth = 0;
  bool _isBuilt = false;

  @override
  Widget build(BuildContext context) {
    // 画面の横幅を取得
    final screenWidthSize = MediaQuery.of(context).size.width;

    // 画面の倍率を計算
    // iphoneProMaxの横幅が430で、それより大きい端末では拡大しない
    final screenHorizontalMagnification =
        screenHorizontalMagnificationGetter(screenWidthSize);

    double degrees = (widget.bigCategorySum / widget.budget);
    barWidth =
        degrees <= 1.0 ? widget.barFrameWidth * degrees : widget.barFrameWidth;

    //ビルドが完了したら横棒グラフのサイズを変更しアニメーションが動く
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBuilt = true;
      });
    });

    // 支出合計のLabel
    final String paymentSumLabel = formattedPriceGetter(widget.bigCategorySum);

    // 予算のLabel
    final String budgetLabel = formattedPriceGetter(widget.budget);

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.quarternarySystemfill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            //themeでwrapするExpansionTileの線が消える
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                listTileTheme: ListTileTheme.of(context).copyWith(
                  titleAlignment: ListTileTitleAlignment.center,
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  dense: true,
                ),
              ),
              child: ExpansionTile(
                // アイコンのカラー
                iconColor: MyColors.white,
                collapsedIconColor: MyColors.white,
                // 右のアイコンのpaddingの設定はここ
                tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                // 開いた後の要素のpadding
                childrenPadding: const EdgeInsets.only(bottom: 10.0),
                
                
                
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      // バーの上下の余白を調整
                      padding: const EdgeInsets.only(top: 8, bottom: 3),
                      child: Stack(
                        children: [
                          // バーの背景枠
                          Container(
                            height: 10,
                            width: widget.barFrameWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.secondarySystemfill,
                            ),
                          ),
                          // バーの中身
                          AnimatedContainer(
                            height: 10,
                            width: _isBuilt ? barWidth : 0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  MyColors().getColorFromHex(widget.colorCode),
                            ),
                            duration: const Duration(milliseconds: 500),
                          ),
                        ],
                      ),
                    ),
                    // バー下ラベル
                    Container(
                      // 最小の制約を設定することで子widgetのRowが最大まで拡大する
                      constraints: BoxConstraints(
                        minWidth: widget.barFrameWidth,
                        minHeight: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // アイコン
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: widget.icon,
                              ),
                              // カテゴリー名
                              Text(
                                widget.categoryName,
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // カテゴリー総支出
                              Text(
                                paymentSumLabel,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSans(
                                    fontSize: 18,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                ' 円',
                                style: GoogleFonts.notoSans(
                                    fontSize: 14,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                ' /',
                                style: GoogleFonts.notoSans(
                                    fontSize: 14,
                                    color: MyColors.secondaryLabel,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '予算 ',
                                style: GoogleFonts.notoSans(
                                    fontSize: 13,
                                    color: MyColors.secondaryLabel,
                                    fontWeight: FontWeight.w400),
                              ),
                              // カテゴリー予算
                              Text(
                                budgetLabel,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSans(
                                    fontSize: 14,
                                    color: MyColors.secondaryLabel,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.end,
                              ),
                              Padding(
                                // 円の右のスペース
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Text(
                                  ' 円',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 11,
                                    color: MyColors.secondaryLabel,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                // expansionArea
                children: [
                  ...List.generate(widget.smallCategorySumList.length, (index) {
                    // 支出合計のLabel
                    final String smallCategoryPaymentSumLabel =
                        formattedPriceGetter(widget.smallCategorySumList[index]
                            ['small_category_payment_sum']);

                    return Padding(
                      // 子一列の両サイドのパディング
                      padding: const EdgeInsets.only(left: 24, right: 52.0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 小カテゴリー名
                          Padding(
                            // 子の中でのパディング
                            padding: const EdgeInsets.only(left: 26.0),
                            child: Text(
                              widget.smallCategorySumList[index]
                                  [TBL201RecordKey().categoryName],
                              style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  color: MyColors.label,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          ),

                          // 小カテゴリーの支払い合計
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                smallCategoryPaymentSumLabel,
                                style: GoogleFonts.notoSans(
                                    fontSize: 18,
                                    color: MyColors.label,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                ' 円',
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  color: MyColors.secondaryLabel,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
