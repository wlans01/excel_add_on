import 'dart:convert';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:csv/csv.dart';

class CsvParser {
  Future<List<dynamic>> parse(XFile csvData)  async{
      File f = File(csvData.path);
      final input = f.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter()).toList();
      return fields;
  }
}