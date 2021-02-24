import 'dart:convert';
import 'dart:io';

import 'package:cable_vasool/api/models/add_connection_model.dart';
import 'package:cable_vasool/api/models/add_setup_box_model.dart';
import 'package:cable_vasool/api/repository.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdminDashboardProvider with ChangeNotifier {
  int _totalCount = 0;
  int _uploadedCount = 0;
  bool _isUploading = false;

  bool get isUploading => _isUploading;

  set isUploading(bool value) {
    _isUploading = value;
  }

  int get totalCount => _totalCount;

  set totalCount(int value) {
    _totalCount = value;
  }

  pickFile(int i) async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result != null) {
      isUploading = true;
      notifyListeners();

      logger.d('result = ${result.files.first.path}');

      File csv = File(result.files.first.path);

      String csvString = await csv.readAsString(encoding: utf8);

      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(csvString);

      logger.d('length - ${rowsAsListOfValues.length}');

      totalCount = rowsAsListOfValues.length;
      notifyListeners();

      if (i == 1) {
        for (List<dynamic> row in rowsAsListOfValues) {
          logger.d(
              'setup box serial - ${row[0]} | operator id - ${row[1]} | provider id - ${row[2]}');

          AddSetupBoxModel model;

          try {
            model = await Repository().addSetupBox(
                setUpBoxSerial: "${row[0]}",
                operatorID: int.parse("${row[1]}"),
                providerID: int.parse("${row[2]}"));
          } catch (e) {
            logger.e('api error - $e');
          }

          // logger.d('model - $model');

          if (model == null) {
            isUploading = false;
            notifyListeners();
            ToastUtils.showToast('Error... Try Again Later');
            break;
          } else {
            if (model?.createSetupBox == null) {
              isUploading = false;
              notifyListeners();
              ToastUtils.showToast('Error... Try Again Later');
              break;
            } else {
              uploadedCount = uploadedCount + 1;
              notifyListeners();
            }
          }
        }
      } else {
        for (List<dynamic> row in rowsAsListOfValues) {
          logger.d(
              'customer_name - ${row[0]} | connection_number - ${row[1]} | due_amount - ${row[2]} | date - ${row[3]} | operator_id - ${row[4]} | line_id - ${row[5]} | setup_box_id - ${row[6]}');

          AddConnectionModel model;


          try {
            model = await Repository().addConnection(
              customerName: "${row[0]}",
              connectionNumber: "${row[1]}",
              dueAmount: int.parse("${row[2]}"),
              connectionAddedDate: "${row[3]}",
              operatorId: int.parse("${row[4]}"),
              lineId: int.parse("${row[5]}"),
              setUpBoxId: int.parse("${row[6]}"),
            );
          }  catch (e) {
            logger.wtf('api error - $e');
          }

          // logger.d('model - $model');

          if (model == null) {
            isUploading = false;
            notifyListeners();
            ToastUtils.showToast('Error... Try Again Later');
            break;
          } else {
            if (model?.createConnection == null) {
              isUploading = false;
              notifyListeners();
              ToastUtils.showToast('Error... Try Again Later');
              break;
            } else {
              uploadedCount = uploadedCount + 1;
              notifyListeners();
            }
          }
        }
      }

      if (uploadedCount == totalCount) {
        isUploading = false;
        notifyListeners();
        ToastUtils.showToast('Uploaded Successful');
      }
    }
  }

  int get uploadedCount => _uploadedCount;

  set uploadedCount(int value) {
    _uploadedCount = value;
  }
}
