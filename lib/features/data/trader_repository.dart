import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/trader_model.dart';

class TraderRepository {
  Future<List<TraderModel>> getTraders() async {
    final jsonString =
        await rootBundle.loadString('assets/data_mockup.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((json) => TraderModel.fromJson(json))
        .toList();
  }
}