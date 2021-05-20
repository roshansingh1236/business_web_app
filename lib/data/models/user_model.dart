import 'package:bussiness_web_app/config/cache.dart';

class UserModel {
  Name name;
  Photo photo;
  String gender;
  bool newUser;
  bool activated;
  bool deleted;
  String sId;
  DepartmentId dDepartmentId;
  UserType userType;
  String familyType;
  String sAssociationId;
  String block;
  int floor;
  String phone;
  String email;

  UserModel(
      {this.name,
      this.photo,
      this.gender,
      this.newUser,
      this.activated,
      this.deleted,
      this.sId,
      this.dDepartmentId,
      this.userType,
      this.familyType,
      this.sAssociationId,
      this.block,
      this.floor,
      this.phone,
      this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    gender = json['gender'];
    newUser = json['newUser'];
    activated = json['activated'];
    deleted = json['deleted'];
    sId = json['_id'];
    // dDepartmentId = json['_departmentId'] != null
    //     ? new DepartmentId.fromJson(json['_departmentId'])
    //     : null;
    // userType = json['userType'] != null
    //     ? new UserType.fromJson(json['userType'])
    //     : null;
    familyType = json['familyType'];
    sAssociationId = json['_associationId'];
    block = json['block'];
    floor = json['floor'];
    phone = json['phone'];
    email = json['email'];
    Cache.storage.setString('associationId', json['_associationId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    data['gender'] = this.gender;
    data['newUser'] = this.newUser;
    data['activated'] = this.activated;
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    if (this.dDepartmentId != null) {
      data['_departmentId'] = this.dDepartmentId.toJson();
    }
    if (this.userType != null) {
      data['userType'] = this.userType.toJson();
    }
    data['familyType'] = this.familyType;
    data['_associationId'] = this.sAssociationId;
    data['block'] = this.block;
    data['floor'] = this.floor;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

class Name {
  String title;
  String first;
  String last;

  Name({this.title, this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }

  String get fullName => title + '. ' + first + ' ' + last;
}

class Photo {
  String uploadedAt;

  Photo({this.uploadedAt});

  Photo.fromJson(Map<String, dynamic> json) {
    uploadedAt = json['uploadedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadedAt'] = this.uploadedAt;
    return data;
  }
}

class DepartmentId {
  String sId;
  String name;

  DepartmentId({this.sId, this.name});

  DepartmentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class UserType {
  String type;
  String sId;

  UserType({this.type, this.sId});

  UserType.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}
