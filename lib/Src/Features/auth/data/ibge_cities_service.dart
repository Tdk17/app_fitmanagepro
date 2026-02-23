import 'dart:convert';

import 'package:app_fitmanagerpro/Src/Features/auth/data/core_data.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IbgeCitiesService {
  IbgeCitiesService({Dio? dio}) : _dio = dio ?? Dio();
  final Dio _dio;

  static const _cacheKey = "ibge_cities_cache_v1";
  static const _cacheAtKey = "ibge_cities_cache_at_v1";
  static const int cacheDays = 30;

  Future<List<BrCity>> getCities({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = prefs.getString(_cacheKey);
      final cachedAt = prefs.getInt(_cacheAtKey);

      if (cached != null && cachedAt != null) {
        final ageMs = DateTime.now().millisecondsSinceEpoch - cachedAt;
        final maxMs = Duration(days: cacheDays).inMilliseconds;

        if (ageMs < maxMs) {
          final list = (jsonDecode(cached) as List)
              .map((e) => BrCity.fromJson((e as Map).cast<String, dynamic>()))
              .toList();
          return list;
        }
      }
    }

    final res = await _dio.get(
      'https://servicodados.ibge.gov.br/api/v1/localidades/municipios',
      options: Options(responseType: ResponseType.json),
    );

    final data = (res.data as List).cast<dynamic>();

    final cities = data
        .map((e) => BrCity.fromIbge((e as Map).cast<String, dynamic>()))
        .where((c) => c.name.isNotEmpty && c.uf.isNotEmpty)
        .toList();

    cities.sort((a, b) {
      final u = a.uf.compareTo(b.uf);
      if (u != 0) return u;
      return a.name.compareTo(b.name);
    });

    final payload = jsonEncode(cities.map((c) => c.toJson()).toList());
    await prefs.setString(_cacheKey, payload);
    await prefs.setInt(_cacheAtKey, DateTime.now().millisecondsSinceEpoch);

    return cities;
  }
}
