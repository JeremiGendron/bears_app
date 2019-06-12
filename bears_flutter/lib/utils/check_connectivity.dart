import 'dart:io';

import 'package:bears_flutter/utils/show_error_snackbar.dart';
import 'package:flutter/material.dart';

const String statusUrl = 'https://status.jeremigendron.com';

Future<bool> checkConnectivity(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup(statusUrl);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    showErrorSnackBar(context, Duration(seconds: 10), "No internet connectivity, the app can't be used.");
    return false;
  } on SocketException catch (_) {
    showErrorSnackBar(context, Duration(seconds: 10), "No internet connectivity, the app can't be used.");
    return false;
  }
}