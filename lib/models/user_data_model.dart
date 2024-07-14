import '../services/cloud_database/database_constant.dart' as db_constant;

class UserData {
  final String name;
  final String email;
  final String id;
  final bool isVerified;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });

  factory UserData.fromMap(Map<String, dynamic> doc) {
    return UserData(
      id: doc[db_constant.id] as String,
      isVerified: doc[db_constant.isVerified],
      name: doc[db_constant.name] as String,
      email: doc[db_constant.email] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      db_constant.id: id,
      db_constant.isVerified: isVerified,
      db_constant.name: name,
      db_constant.email: email,
    };
  }

  UserData copyWith({
    String? name,
    String? email,
    String? id,
    bool? isVerified,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
