
class ClientModel {
  int id;
  String name;
  String mobile;


  ClientModel({
    this.id,
    this.name,
    this.mobile,
  });

  factory ClientModel.fromJson(Map<String, dynamic>json )=> ClientModel (
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
    'mobile': mobile,
  };

}


