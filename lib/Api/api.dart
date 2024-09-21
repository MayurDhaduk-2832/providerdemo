import 'dart:convert';
import 'package:http/http.dart' as http;

class CallApi {
  postData(data, apiUrl) async {
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl');
    return await http.post(baseUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postSocket(data, apiUrl) async {
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl');
    // var baseUrl = Uri.https('www.oneqlik.in','/$apiUrl');
    print("baseurl is------------:$baseUrl");
    return await http.post(baseUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getDataAsParams(data, apiUrl) async {
    print("data is------------:$apiUrl");
    print("data is------------:$data");
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl', data);
    print("baseurls is------------:$baseUrl");
    return await http.get(baseUrl, headers: _setHeaders());
  }

  getAsParams(apiUrl) async {
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl');
    print("baseurl is------------:$baseUrl");
    return await http.get(baseUrl, headers: _setHeaders());
  }

  postDataAsParams(data, apiUrl) async {
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl', data);
    print("baseurl is------------:$baseUrl");
    return await http.get(baseUrl, headers: _setHeaders());
  }

  getDataAsParamsSocket(data, apiUrl) async {
    // var baseUrl = Uri.https('soc.oneqlik.in','/$apiUrl',data);
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl', data);
    print("baseurl is------------:$baseUrl");
    return await http.get(baseUrl, headers: _setHeaders());
  }

  getData(data, apiUrl) async {
    var baseUrl = Uri.https('www.oneqlik.in', '/$apiUrl', data);
    print("baseurl is------------:$baseUrl");
    return await http.get(baseUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
      };
}
