// class UserModel {
//   late int id;
//   final String email;
//   final String username;

//   UserModel._({required this.email, required this.username});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return new UserModel._(
//       email: json['email'],
//       username: json['username'],
//     );
//   }
// }

class Userget {
  String? email;
  int? id;
  String? username;

  Userget(user, {this.email, this.id, this.username});

  Userget.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}

class UsersDataModel {
   int id;
   String username;
   String email;
  UsersDataModel({required this.id, required this.username, required this.email});

  factory UsersDataModel.fromJson(Map<String, dynamic> usersjson)=> UsersDataModel(
      id: usersjson["id"],
      username: usersjson["username"],
      email: usersjson["email"],
  );
}

// class UsersDataModel {
//   int id;
//   String username;
//   String email;
//   List items;
//   UsersDataModel(
//       {required this.id, required this.username, required this.email, required this.items});

//   factory UsersDataModel.fromJson(Map<String, dynamic> usersjson) {
//     // Below 2 line code is parsing JSON Array of items in our JSON Object (YouttubeResponse)

//     var list = usersjson as List;
//     List<Item> itemsList = list.map((i) => Item.fromJSON(i)).toList();

//     return new UsersDataModel(
//         id: usersjson['id'],
//         email: usersjson['email'],
//         username: usersjson['username'],

//         // Here we are returning parsed JSON Array.

//         items: itemsList);
//   }
// }
