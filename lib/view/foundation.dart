import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakeibo/constant/colors.dart';
import 'package:kakeibo/view/page/third_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:kakeibo/view_model/provider/navigation_bar.dart';
import 'package:kakeibo/view_model/provider/initial_open.dart';
import 'package:kakeibo/view/page/torok.dart';
import 'package:kakeibo/view/page/home.dart';

class Foundation extends HookConsumerWidget {
  const Foundation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //navigationBarの状態管理
    final navigationBarState = ref.watch(navigationBarNotifierProvider);

    //アプリを開いた時か判定
    //開いた時なら登録画面を表示
    ref.listen(initialOpenNotifierProvider, (oldState, newState) {
      //なんもしやん
    });
    final isInitialOpen = ref.read(initialOpenNotifierProvider);
    //WidgetsBindingで囲むことで、ビルドが終わったタイミングで中の処理が走る
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInitialOpen == true) {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (_) => const Torok(),
          isDismissible: true,
        );
        final notifier = ref.read(initialOpenNotifierProvider.notifier);
        notifier.updateState();
      }
    });


    //navigationBarに設定するbodyのpageリスト
    List<Widget> pageList = [const Home(), const Third()];

    //nvigationBarに設定するpageのpath
    // Map<String, WidgetBuilder> routes = {
    //   '/home': (BuildContext context) => const Home(),
    //   '/torok': (BuildContext context) => const Torok(),
    // };

    useEffect(() {
      print('buildされました');
      return (() {
        print('disposeされました');
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.jet,
        title: const SizedBox(
          child: Text('kakeibo'),
        ),
      ),
      body: MaterialApp(
        //   onGenerateRoute: (settings) {
        //   return MaterialWithModalsPageRoute(
        //     settings: settings,
        //     builder: (context) => pageList[navigationBarState],
        //   );
        // },
        //ここにroutesを設定することによって、navigationBarを除いてページ遷移できる
        // routes: routes,
        home: pageList[navigationBarState],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
            context: context,
            builder: (_) => const Torok(),
            isDismissible: true,
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.jet,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.plus_one), label: 'Torok')
        ],
        currentIndex: navigationBarState,
        onTap: (int index) {
          // watchで取ってきたステート(viewのstate)にタップされた引数(index)番目のViewTypeを代入する
          final notifier = ref.read(navigationBarNotifierProvider.notifier);
          notifier.updateState(index);
        },
      ),
    );
  }
}
