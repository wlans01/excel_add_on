import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel_add_on/common/csv/csv_parser.dart';
import 'package:excel_add_on/home/model/files_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';

final filesProvider = StateNotifierProvider<FilesProvider, FilesModel>(
  (ref) => FilesProvider(),
);

class FilesProvider extends StateNotifier<FilesModel> {
  final parser = CsvParser();

  FilesProvider()
      : super(
          FilesModel(files: [], col: 0, row: 0, firstData: [], copyData: []),
        );

  void fileAdd(files) async {
    final List<XFile> csvFiles = files.files
        .where((e) =>
            e.path.endsWith('csv') ||
            e.path.endsWith('xlsx') ||
            e.path.endsWith('txt'))
        .toList();

    state = state.copyWith(files: [...state.files, ...csvFiles]);
    getFirstFileData();
    //TODO 정렬기능
  }

  void fileRemove(XFile file) async {
    state = state.copyWith(files: state.files.where((e) => e != file).toList());
    if (state.files.isEmpty) {
      state =
          FilesModel(files: [], col: 0, row: 0, firstData: [], copyData: []);
    }
  }

  void removeAll() {
    state = FilesModel(files: [], col: 0, row: 0, firstData: [], copyData: []);
  }

  void addAll({
    required int up,
    required int down,
    required int left,
    required int right,
  }) async {
    if (state.files.isEmpty) return;
    final data = await Future.wait(state.files.map((element) async {
      File f = File(element.path);
      final input = f.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      final dataIndexingCol = fields.getRange(up, down).toList();
      final dataIndexingRow =
          dataIndexingCol.map((e) => e.getRange(left, right).toList()).toList();
      return dataIndexingRow;
    }).toList());
    final firstData = data.first;
    final firstDataLength = firstData.length;
    data.removeAt(0);

    for (var element in data) {
      for (int i = 0; i < firstDataLength; i++) {
        firstData[i].addAll(element[i]);
      }
    }
    final result = const ListToCsvConverter().convert(firstData);
    const path = "result.csv";
    final File file = File(path);
    try {
      await file.writeAsString(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFirstFileData() async {
    if (state.files.isEmpty) return;
    File f = File(state.files.first.path);
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    final col = fields.length;
    final row = fields.first.length;
    state =
        state.copyWith(col: col, row: row, firstData: fields, copyData: fields);
  }

  Future<void> cutFirstFiled({
    required int up,
    required int down,
    required int left,
    required int right,
  }) async {
    if (state.files.isEmpty) return;
    File f = File(state.files.first.path);
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    final dataIndexingCol = fields.getRange(up, down).toList();
    final dataIndexingRow =
        dataIndexingCol.map((e) => e.getRange(left, right).toList()).toList();
    state = state.copyWith(copyData: dataIndexingRow);
  }
}
