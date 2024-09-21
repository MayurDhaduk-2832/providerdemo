import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/save_pdf_excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> generatePdf(list,vehicleID) async {

  //Create a new PDF document
  PdfDocument document = PdfDocument();

  //Create a PdfGrid class
  PdfGrid grid = PdfGrid();

  List<PdfGridRow> rowList=[];


  //Add the columns to the grid
  grid.columns.add(count: 1);

  //Add header to the grid
  grid.headers.add(1);

  //Add the rows to the grid
  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Vehicle Id: $vehicleID';



  header.cells[0].style =PdfGridCellStyle(
    cellPadding: PdfPaddings(left: 2, right: 3, top: 10, bottom: 10),
    backgroundBrush: PdfSolidBrush(PdfColor(36, 40, 46, 1)),
    textBrush: PdfBrushes.white,
  );

  header.cells[0].style.stringFormat = PdfStringFormat(
    alignment: PdfTextAlignment.center,
  );

  for(int i =0;i<list.length; i++){
    rowList.add(grid.rows.add());
     rowList[i].cells[0].value = list[i];
  }


  //Set the grid style
  grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 10, bottom: 10),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfSolidBrush(PdfColor(36, 40, 46, 1)),
      // font: PdfStandardFont(PdfFontFamily.helvetica, 25)
  );

  //Draw the grid
  grid.draw(page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  //Save and dispose the PDF document
  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();

  await saveAndLaunchFile(bytes, '$vehicleID-${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}.pdf');

}