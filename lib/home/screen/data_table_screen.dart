import 'package:excel_add_on/home/model/files_model.dart';
import 'package:excel_add_on/home/provider/files_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataTablePage extends ConsumerStatefulWidget {
  const DataTablePage({Key? key}) : super(key: key);

  @override
  ConsumerState<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends ConsumerState<DataTablePage> {
  List<DataColumn> _getColumns(FilesModel state) {
    List<DataColumn> dataColumn = [
      const DataColumn(label: Text('index'), tooltip: 'index')
    ];

    for (var i = 0; i < state.copyData.first.length; i++) {
      dataColumn
          .add(DataColumn(label: Text(i.toString()), tooltip: i.toString()));
    }

    return dataColumn;
  }

  List<DataRow> _getRows(FilesModel state) {
    List<DataRow> dataRow = [];
    for (var i = 0; i < state.copyData.length - 1; i++) {
      var csvDataCells = [i.toString(), ...state.copyData[i]];

      List<DataCell> cells = [];

      for (var j = 0; j < csvDataCells.length; j++) {
        cells.add(DataCell(Text(csvDataCells[j].toString())));
      }

      dataRow.add(DataRow(cells: cells));
    }

    return dataRow;
  }

  Widget _getDataTable(FilesModel state) {
    return DataTable(
      horizontalMargin: 12.0,
      columnSpacing: 28.0,
      columns: _getColumns(state),
      rows: _getRows(state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(state.files.first.name),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: _getDataTable(state),
          ),
        ));
  }
}
