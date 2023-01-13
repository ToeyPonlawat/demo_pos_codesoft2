import 'dart:typed_data';
import 'package:demo_pos_codesoft/printerenum.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:http/http.dart' as http;

///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // sample() async {
  //   //image max 300px X 300px
  //
  //   ///image from File path
  //   String filename = 'yourlogo.png';
  //   ByteData bytesData = await rootBundle.load("assets/images/yourlogo.png");
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
  //       .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));
  //
  //   ///image from Asset
  //   ByteData bytesAsset = await rootBundle.load("assets/images/yourlogo.png");
  //   Uint8List imageBytesFromAsset = bytesAsset.buffer
  //       .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);
  //
  //   // ///image from Network
  //   // var response = await http.get(Uri.parse(
  //   //     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
  //   // Uint8List bytesNetwork = response.bodyBytes;
  //   // Uint8List imageBytesFromNetwork = bytesNetwork.buffer
  //   //     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);
  //
  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected == true) {
  //       // bluetooth
  //       //     .paperCut();
  //       // bluetooth.printNewLine();
  //       bluetooth.printCustom("HEADER2", Size.boldMedium.val, Align.center.val);
  //       // bluetooth.printNewLine();
  //       // bluetooth.printQRcode(
  //       //     "Insert Your Own Text to Generate", 200, 200, Align.center.val);
  //       // bluetooth.printImageBytes(imageBytesFromNetwork); //image from Network
  //       bluetooth.printNewLine();
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.medium.val);
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val);
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val,
  //           format:
  //               "%-15s %15s %n"); //15 is number off character from left or right
  //       bluetooth.printNewLine();
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldMedium.val);
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldLarge.val);
  //       bluetooth.printLeftRight("LEFT", "RIGHT", Size.extraLarge.val);
  //       bluetooth.printNewLine();
  //       bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val);
  //       bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val,
  //           format:
  //               "%-10s %10s %10s %n"); //10 is number off character from left center and right
  //       bluetooth.printNewLine();
  //       bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val);
  //       bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val,
  //           format: "%-8s %7s %7s %7s %n");
  //       // bluetooth.printNewLine();
  //       // bluetooth.printCustom("Body left", Size.bold.val, Align.left.val);
  //       // bluetooth.printCustom("Body right", Size.medium.val, Align.right.val);
  //       // bluetooth.printNewLine();
  //       // bluetooth.printCustom("Thank You", Size.bold.val, Align.center.val);
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       // bluetooth.printNewLine();
  //       bluetooth
  //           .paperCut();
  //       bluetooth
  //           .paperCut();//some printer not supported (sometime making image not centered)
  //       //bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
  //     }
  //   });
  // }

  cut() async {
    bluetooth.isConnected.then((isConnected) {
      bluetooth.paperCut();
    });
  }

  imagePrint(Uint8List bytes) async{

    Uint8List imageBytesFromNetwork = bytes.buffer
        .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    bluetooth.isConnected.then((isConnected) async {
      if (isConnected == true) {
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        // bluetooth.printNewLine();
        bluetooth.printImageBytes(imageBytesFromNetwork);
        bluetooth.printNewLine();
        bluetooth.printCustom("Powered by API Innovation ", 1, 1);}
    });
  }

  sample() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    ///image from Network
    // var response = await http.get(Uri.parse(
    //     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    // Uint8List bytesNetwork = response.bodyBytes;
    // Uint8List imageBytesFromNetwork = bytesNetwork.buffer
    //     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);


    bluetooth.isConnected.then((isConnected) async {
      if (isConnected == true) {
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        bluetooth.printCustom("HEADER", 3, 1);
        // bluetooth.printNewLine();
        // bluetooth.printImageBytes(imageBytesFromNetwork); //image from Network
        // bluetooth.printNewLine();
//      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        bluetooth.printLeftRight("LEFT", "RIGHT", 3);
        bluetooth.printLeftRight("LEFT", "RIGHT", 4);
        bluetooth.printNewLine();
        bluetooth.print3Column("Col1", "Col2", "Col3", 1);
        bluetooth.print3Column("Col1", "Col2", "Col3", 1,
            format: "%-10s %10s %10s %n");
        bluetooth.printNewLine();
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
            format: "%-8s %7s %7s %7s %n");
        bluetooth.printNewLine();

        bluetooth.printCustom("Body left", 1, 0);
        bluetooth.printCustom("Body right", 0, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank Cut No cut2 ", 2, 1);
        // bluetooth.printImageBytes(bytes2?.buffer.asUint8List());

        // bluetooth.printImageBytes(bytes2?.buffer.asUint8List(bytes2.offsetInBytes,bytes2.lengthInBytes));
        // bluetooth.printCustom("ทดสอบภาษาไทย", 1, 1, charset: "windows-1251");

        // bluetooth.printCustom(encThai.toString(), 1, 1);
        // bluetooth.printImageBytes(encThai.buffer.asUint8List(encThai.offsetInBytes,encThai.lengthInBytes)); //image from Network
      }
    });

    // bluetooth.paperCut();
  }

}
