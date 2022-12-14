class User {
  String id = '';
  String image, gender, username, email, password, address;

  User({
    this.id = '',

    required this.image,
    required this.gender,
    required this.username, 
    required this.email, 
    required this.password, 
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'gender': gender,
    'image': image,
    'username': username,
    'email': email,
    'password': password,
    'address': address,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    image: json['image'],
    gender: json['gender'],
    username: json['username'],
    email: json['email'],
    password: json['password'],
    address: json['address'],
  );

}