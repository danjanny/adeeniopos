import 'dart:convert';

import 'package:app/api_endpoint.dart';
import 'package:app/order/models/report_model.dart';
import 'package:app/simple_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier {
  ReportResponse? get reportResponse => _reportResponse;
  ReportResponse? _reportResponse;

  Future<ReportResponse?> getReport(Map<String, String> queryParams) async {
    ReportResponse reportResponse;
    try {
      var uri =
          Uri.http(ApiEndpoint.plainDomain, ApiEndpoint.reportUrl, queryParams);

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      };

      var reportResponseHttp = await http.get(uri, headers: headers);
      var reportResponseObj =
          ReportResponse.fromJson(jsonDecode(reportResponseHttp.body));

      if (reportResponseObj.status == 'error') {
        throw SimpleException(reportResponseObj.message);
      }

      _reportResponse = reportResponseObj;
      reportResponse = reportResponseObj;
      notifyListeners();
    } catch (e) {
      var reportResponseError = ReportResponse.error("error", e.toString());
      _reportResponse = reportResponseError;
      reportResponse = reportResponseError;
      notifyListeners();
    }
    return reportResponse;
  }
}
