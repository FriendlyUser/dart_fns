import 'package:dart_appwrite/dart_appwrite.dart';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<String> getIpAddress() async {
  try {
    var response = await http.get(Uri.parse('https://jsonip.com'));
    var json = response.body;
    if (json == "") {
      throw Exception("Invalid response");
    }
    var jsonResponse = jsonDecode(json) as Map<String, dynamic>;
    return jsonResponse['ip'] as String;
  } catch (e) {
    print(e);
    rethrow;
  }
}

class IPResponse {
  String ip;
  String registry;
  String countrycode;
  String countryname;
  Asn asn;
  bool spam;
  bool tor;
  String city;
  String detail;
  List<String> website;

  IPResponse({
    required this.ip,
    required this.registry,
    required this.countrycode,
    required this.countryname,
    required this.asn,
    required this.spam,
    required this.tor,
    required this.city,
    required this.detail,
    required this.website,
  });

  factory IPResponse.fromJson(Map<String, dynamic> json) {
    return IPResponse(
      ip: json['ip'],
      registry: json['registry'],
      countrycode: json['countrycode'],
      countryname: json['countryname'],
      asn: Asn.fromJson(json['asn']),
      spam: json['spam'],
      tor: json['tor'],
      city: json['city'],
      detail: json['detail'],
      website: List<String>.from(json['website']),
    );
  }
}

class Asn {
  String code;
  String name;
  String route;
  String start;
  String end;

  Asn({
    required this.code,
    required this.name,
    required this.route,
    required this.start,
    required this.end,
  });

  factory Asn.fromJson(Map<String, dynamic> json) {
    return Asn(
      code: json['code'],
      name: json['name'],
      route: json['route'],
      start: json['start'],
      end: json['end'],
    );
  }
}

Future<IPResponse> getIpInfo(String ip) async {
  try {
    var response = await http.get(Uri.parse('https://iplist.cc/api/$ip'));
    var json = response.body;
    if (json == "") {
      throw Exception("Invalid response");
    }
    var jsonResponse = jsonDecode(json) as Map<String, dynamic>;
    return IPResponse.fromJson(jsonResponse);
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<void> start(final req, final res) async {
  final client = Client();

  // Uncomment the services you need, delete the ones you don't
  // final account = Account(client);
  // final avatars = Avatars(client);
  // final database = Databases(client);
  // final functions = Functions(client);
  // final health = Health(client);
  // final locale = Locale(client);
  // final storage = Storage(client);
  // final teams = Teams(client);
  // final users = Users(client);

  if (req.variables['APPWRITE_FUNCTION_ENDPOINT'] == null ||
      req.variables['APPWRITE_FUNCTION_API_KEY'] == null) {
    print(
        "Environment variables are not set. Function cannot use Appwrite SDK.");
  } else {
    client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'])
        .setSelfSigned(status: true);
  }
  final ip = await getIpAddress();
  final ipInfo = await getIpInfo(ip);
  res.json({
    'ip': ip,
    'ipInfo': ipInfo,
  });
}
