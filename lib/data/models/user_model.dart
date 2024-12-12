class UserModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  double? latitude;
  double? longitude;

  UserModel({
     this.id,
     this.name,
     this.email,
     this.imageUrl,
     this.latitude,
     this.longitude,
  });

  factory UserModel.fromMap(String id,Map<String, dynamic> data) => UserModel(
    id: id,
    name: data['name'],
    email: data['email'],
    imageUrl: data['imageUrl'],
    latitude: data['latitude'],
    longitude: data['longitude'],
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
