import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/save_pdf_excel.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> generateExcel(listTitle,vehicleName,excelTitle) async {

  final Workbook workbook = Workbook();

  final Worksheet sheet = workbook.worksheets[0];
  sheet.showGridlines = true;

  sheet.enableSheetCalculations();

  sheet.getRangeByName('A1').setText(excelTitle[0]);
  sheet.getRangeByName('B1').setText(excelTitle[1]);
  sheet.getRangeByName('C1').setText(excelTitle[2]);
  sheet.getRangeByName('D1').setText(excelTitle[3]);
  sheet.getRangeByName('E1').setText(excelTitle[4]);
  sheet.getRangeByName('F1').setText(excelTitle[5]);
  sheet.getRangeByName('G1').setText(excelTitle[6]);
  sheet.getRangeByName('H1').setText(excelTitle[7]);
  sheet.getRangeByName('I1').setText(excelTitle[8]);
  sheet.getRangeByName('J1').setText(excelTitle[9]);
  sheet.getRangeByName('K1').setText(excelTitle[10]);
  sheet.getRangeByName('L1').setText(excelTitle[11]);
  sheet.getRangeByName('A1').cellStyle.fontName = "Poppins-SemiBold";

  for(int i=0; i<listTitle.length; i++){
   // sheet.getRangeByIndex((i+1), i).setText(listTitle[i]);
    sheet.getRangeByName('A${i+2}').setText(listTitle[i]['a'].toString());
    sheet.getRangeByName('B${i+2}').setText(listTitle[i]['b'].toString());
    sheet.getRangeByName('C${i+2}').setText(listTitle[i]['c'].toString());
    sheet.getRangeByName('D${i+2}').setText(listTitle[i]['d'].toString());
    sheet.getRangeByName('E${i+2}').setText(listTitle[i]['e'].toString());
    sheet.getRangeByName('F${i+2}').setText(listTitle[i]['f'].toString());
    sheet.getRangeByName('G${i+2}').setText(listTitle[i]['g'].toString());
    sheet.getRangeByName('H${i+2}').setText(listTitle[i]['h'].toString());
    sheet.getRangeByName('I${i+2}').setText(listTitle[i]['i'].toString());
    sheet.getRangeByName('J${i+2}').setText(listTitle[i]['j'].toString());
    sheet.getRangeByName('K${i+2}').setText(listTitle[i]['k'].toString());
    sheet.getRangeByName('L${i+2}').setText(listTitle[i]['l'].toString());
    sheet.getRangeByName('A${i+2}').columnWidth = 15;
    sheet.getRangeByName('B${i+2}').columnWidth = 20;
    sheet.getRangeByName('C${i+2}').columnWidth = 15;
    sheet.getRangeByName('D${i+2}').columnWidth = 80;
    sheet.getRangeByName('E${i+2}').columnWidth = 15;
    sheet.getRangeByName('F${i+2}').columnWidth = 15;
    sheet.getRangeByName('G${i+2}').columnWidth = 15;
    sheet.getRangeByName('H${i+2}').columnWidth = 15;
    sheet.getRangeByName('I${i+2}').columnWidth = 15;
    sheet.getRangeByName('J${i+2}').columnWidth = 15;
    sheet.getRangeByName('K${i+2}').columnWidth = 15;
    sheet.getRangeByName('L${i+2}').columnWidth = 15;
  }


  //Save and launch the excel.
  final List<int> bytes = workbook.saveAsStream();
  //Dispose the document.
  workbook.dispose();

  //Save and launch the file.
  await saveAndLaunchFile(bytes, '$vehicleName-${DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.now())}.xlsx');

}
