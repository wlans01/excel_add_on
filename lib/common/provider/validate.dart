//숫자
import 'package:excel_add_on/home/model/files_model.dart';
import 'package:excel_add_on/home/provider/files_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final numValidateProvider = ChangeNotifierProvider(
  (ref) => NumValidate(ref: ref),
);

class NumValidate extends ChangeNotifier {
  final Ref ref;
  late FilesModel state;

  NumValidate({
    required this.ref,
  }) {
    state = ref.watch(filesProvider);
  }

  //up
  String? upValidate(String? value) {
    bool isEmailValidate = (value == null || value.isEmpty);

    if (isEmailValidate) return '빈칸놉';

    return null;
  }

  //down
  String? downValidate(String? value) {
    bool isEmailValidate = (value == null || value.isEmpty);
    if (isEmailValidate) return '빈칸놉';
    final num = int.parse(value);
    if (num > state.col) return 'Max Col overflow';

    return null;
  }

  //left
  //right
  String? rightValidate(String? value) {
    bool isEmailValidate = (value == null || value.isEmpty);
    if (isEmailValidate) return '빈칸놉';
    final num = int.parse(value);
    if (num > state.row) return 'Max Row overflow';

    return null;
  }
}
