class ProfileDto {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? dateOfBirth;
  final int? gender;
  final String? address;
  final String? city;
  final String? district;
  final String? bio;

  ProfileDto({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.district,
    this.bio,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      district: json['district'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (fullName != null) 'fullName': fullName,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (bio != null) 'bio': bio,
    };
  }

  ProfileDto copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? dateOfBirth,
    int? gender,
    String? address,
    String? city,
    String? district,
    String? bio,
  }) {
    return ProfileDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      bio: bio ?? this.bio,
    );
  }
}
