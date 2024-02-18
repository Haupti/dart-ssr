import 'dart:convert';
import 'dart:io';

enum AuthRole {
  none(0),
  basic(1),
  mod(2),
  admin(3);

  final int level;
  const AuthRole(this.level);
  static AuthRole fromLevel(int level){
    AuthRole role;
    switch(level){
      case 0: role = none;
      case 1: role = basic;
      case 2: role = mod;
      case 3: role = admin;
      case >3: role = admin;
      default: role = none;
    }
    return role;
  }
}

class User {
  String username;
  String password;
  AuthRole role;

  User({required this.username, required this.password, required this.role});

  bool verifyBasicAuth(String basicAuth){
    return basicAuth == "$username:$password";
  }

  bool isAuthorized(AuthRole minRequiredRole){
    return minRequiredRole.level <= role.level;
  }

  Map<String, dynamic> toJson(){
    return{
      "username": username,
      "password": password,
      "authLevel": role.level,
    };
  }

  static User fromJson(Map<String, dynamic> jsonMap){
    int level = jsonMap["authLevel"];
    AuthRole role = AuthRole.fromLevel(level);
    return User(username: jsonMap["username"], password: jsonMap["password"], role: role);
  }
}

User? currentUser;
AuthRole getCurrentAuthorizedUserRole() {
  if(currentUser != null){
    return currentUser!.role;
  } else {
    return AuthRole.none;
  }
}

List<User> getUsers(File usersFile){
  if(!usersFile.existsSync()){
    return [];
  }
  String jsonArrayString = usersFile.readAsStringSync();
  if(jsonArrayString.isEmpty){
    return [];
  }
  List<dynamic> array = jsonDecode(jsonArrayString);

  List<User> users = [];
  for(final node in array){
    try{
      users.add(User.fromJson(node) );
    } catch(e) {
      print("ERROR: could not read from file: $e");
      exit(1);
    }
  }
  return users;
}
