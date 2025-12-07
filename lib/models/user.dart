class User {
  final int id;
  final String name;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Handle case where data might be nested
      Map<String, dynamic> userData = json;
      
      // Add defensive coding to handle missing fields
      final id = (userData['id'] as num?)?.toInt();
      final name = userData['name'] as String?;
      final email = userData['email'] as String?;
      final token = userData['token'] as String?;
      
      if (id == null || name == null || email == null || token == null) {
        throw Exception('Missing required fields in user data');
      }
      
      return User(
        id: id,
        name: name,
        email: email,
        token: token,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}