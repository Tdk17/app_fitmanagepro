class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role; // "professor" | "aluno"
  final String? sessionToken;

  UserModel({this.id, this.name, this.email, this.role, this.sessionToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['objectId'] ?? json['id'],
      name: json['name'] ?? json['nome'],
      email: json['email'],
      role: json['role'] ?? json['tipo'],
      sessionToken: json['sessionToken'] ?? json['token'],
    );
  }
}
