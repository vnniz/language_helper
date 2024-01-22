import 'dart:convert';
import 'dart:io';

import 'package:language_helper/src/utils/print_debug.dart';

import '../../language_helper.dart';

Map<String, dynamic> languageDataToMap(LanguageData data) {
  return data.map((key, value) {
    value = value.map((key, value) {
      if (value is LanguageConditions) {
        return MapEntry(key, value.toMap());
      }

      return MapEntry(key, value);
    });

    return MapEntry(key.code, value);
  });
}

LanguageData languageDataFromMap(Map<String, dynamic> map) {
  return map.map((key, value) {
    // Reorganize the `value` back to String and LanguageCondition
    value = (value as Map<String, dynamic>).map((key, value) {
      //  Try to decode the data back to the LanguageCondition
      if (value is Map) {
        return MapEntry(
          key,
          LanguageConditions.fromMap(value.cast<String, dynamic>()),
        );
      }

      return MapEntry(key, value);
    });
    return MapEntry(LanguageCodes.fromCode(key), value.cast<String, dynamic>());
  });
}

void exportJson(LanguageData data, String path) {
  printDebug('===========================================================');
  printDebug('Exporting Json...');
  _exportJsonCodes(data, path);
  _exportJsonLanguages(data, path);
  printDebug('Exported Json');
  printDebug('===========================================================');
}

void _exportJsonCodes(LanguageData data, String path) {
  printDebug('Creating codes.json...');

  final desFile = File('$path/resources/language_helper/json/codes.json');
  desFile.createSync(recursive: true);
  final codes = data.keys.map((e) => e.code).toList();
  desFile.writeAsStringSync(jsonEncode(codes));

  printDebug('Created codes.json');
}

void _exportJsonLanguages(LanguageData data, String path) {
  printDebug('Creating languages json files...');

  final desPath = '$path/resources/language_helper/json/languages/';
  final map = languageDataToMap(data);
  for (final MapEntry(key: String key, value: dynamic value) in map.entries) {
    final desFile = File('$desPath$key.json');
    desFile.createSync(recursive: true);
    final data = jsonEncode({key: value});
    desFile.writeAsStringSync(data);
  }

  printDebug('Created languages json files');
}
