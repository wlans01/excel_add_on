import 'package:excel_add_on/common/layout/default_layout.dart';
import 'package:excel_add_on/home/provider/files_provider.dart';
import 'package:excel_add_on/home/screen/data_table_screen.dart';
import 'package:excel_add_on/home/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/style.dart';

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
              child: Container(
                padding: const EdgeInsets.all(DEFAULT_PADDING),
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: fileState.firstData.isEmpty
                    ? const Text('파일없음')
                    : const DataTablePage(),
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
