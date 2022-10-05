import 'package:excel_add_on/common/layout/default_layout.dart';
import 'package:excel_add_on/home/provider/files_provider.dart';
import 'package:excel_add_on/home/screen/data_table_screen.dart';
import 'package:excel_add_on/home/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../common/const/style.dart';
import '../../common/const/text.dart';

class HomeScreen extends ConsumerWidget {
  static String get routeName => 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileState = ref.watch(filesProvider);
    return DefaultLayout(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Neumorphic(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: double.infinity,
                  child: fileState.firstData.isEmpty
                      ? Text(app_description)
                      : const DataTablePage(),
                ),
              ),
            ),
            const SizedBox(
              width: DEFAULT_PADDING,
            ),
            const Settings(),
          ],
        ),
      ),
    );
  }
}

