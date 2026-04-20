import 'package:dalalat_quran_light/models/row_model_entity.dart';

class LineModel {
  int? lineNo;

  LineModel(this.lineNo, this.lineData);

  List<RowModel>? lineData;
}
