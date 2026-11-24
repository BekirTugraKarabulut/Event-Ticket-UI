import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DtoUserInfo {
  final String username;
  final String name;
  final String surname;
  final String phoneNumber;

  DtoUserInfo({
    required this.username,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  factory DtoUserInfo.fromJson(Map<String, dynamic> json) {
    return DtoUserInfo(
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}