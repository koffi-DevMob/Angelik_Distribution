
class ItemModel {
  int id;
  int id_b6;
  int id_b12;
  int Qtiteb6;
  int Qtiteb12;
  int user_id;
  int contact_id;
  int amount;
  int final_total;

  ItemModel({
    this.id,
    this.id_b6,
    this.id_b12,
    this.Qtiteb6,
    this.Qtiteb12,
    this.user_id,
    this.amount,
    this.final_total,
    this.contact_id
  });

  factory ItemModel.fromJson(Map<String, dynamic>json )=> ItemModel (
    id: json["id"],
    id_b6: json["id_b6"],
    id_b12: json["id_b12"],
    Qtiteb6: json["Qtiteb6"],
    Qtiteb12: json["Qtiteb12"],
    user_id: json["user_id"],
    amount: json["amount"],
    final_total: json["final_total"],
    contact_id: json["contact_id"],
  );

  Map<String, dynamic> toJson() => {
    ' id':id,
    ' id_b6':id_b6,
    'id_b12': id_b12,
    ' Qtiteb6':Qtiteb6,
    'Qtiteb12':Qtiteb12,
    'user_id':user_id,
    'amount':amount,
    'final_total':final_total,
    'contact_id':contact_id
  };

}


