import 'package:cross_file/cross_file.dart';

class FilesModel {
  FilesModel({
    required this.files,
    required this.row,
    required this.col,
    required this.firstData,
    required this.copyData,
  });

  final List<XFile> files;
  final List<List<dynamic>> firstData;
  final List<List<dynamic>> copyData;

  final int row;
  final int col;

  FilesModel copyWith({
    List<XFile>? files,
    List<List<dynamic>>? firstData,
    List<List<dynamic>>? copyData,
    int? row,
    int? col,
  }) {
    return FilesModel(
      files: files ?? this.files,
      firstData: firstData ?? this.firstData,
      copyData: copyData ?? this.copyData,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }
}
