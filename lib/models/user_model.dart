import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userEmail;
  final Timestamp createdAt;
  final List userCart;
  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userCart,
    required this.createdAt,
  });
}
