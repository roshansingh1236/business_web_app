class TokenModel {
  String token;
  String expiresIn;

  TokenModel({this.token, this.expiresIn});

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiresIn'] = this.expiresIn;
    return data;
  }
}
