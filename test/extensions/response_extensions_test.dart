import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/extensions/response_extensions.dart';

void main() {
  setUp(() {});

  test('success 200', () {
    final resp = http.Response('Success', 200);
    expect(() => resp.ensureSuccessStatusCode(), returnsNormally);
  });

  test('success 299', () {
    final resp = http.Response('Success', 299);
    expect(() => resp.ensureSuccessStatusCode(), returnsNormally);
  });

  test('success between 200 & 299', () {
    final resp = http.Response('Success', Random().nextInt(97) + 201);
    expect(() => resp.ensureSuccessStatusCode(), returnsNormally);
  });

  test('fail 404', () {
    final resp = http.Response('Not found', 404);
    expect(() => resp.ensureSuccessStatusCode(), throwsException);
  });
}
