import 'package:app_fitmanagerpro/Src/Db/auth_endPoints.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';

class DashboardApi {
  DashboardApi(this._http);
  final HttpManager _http;

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _http.restRequest(
      url: AuthEndpoints.deshboard,
      method: HttpMethod.post,
      body: {},
    );

    final r = res['result'];
    if (r is Map<String, dynamic>) return r;
    if (r is Map) return r.cast<String, dynamic>();

    return res;
  }
}
