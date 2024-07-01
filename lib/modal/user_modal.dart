import 'package:flutter/material.dart';

class UserModal {
  String id;
  String name;
  String email;
  String profilepic;

  UserModal({
    required this.id,
    required this.name,
    required this.email,
    required this.profilepic,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        profilepic: data['profilepic']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilepic': profilepic,
    };
  }
}
