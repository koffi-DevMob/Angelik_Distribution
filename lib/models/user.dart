// @dart=2.9
import 'package:shared_preferences/shared_preferences.dart';
class User{
final int id;
final String userName;
final int businessId;
final int locationId;
final int missionId;
final int reference_bl;

  User({
    this.id,
    this.userName,
    this.businessId,
    this.locationId,
    this.missionId,
    this.reference_bl,

  });

  factory User.fromMap(Map<String,dynamic> map){
    if(map==null) return null;

    return User(
      id: map['user_id'],
      userName: map['username'],
      businessId: map['business_id'],
      locationId: map['location_id'],
        missionId: map['mission_id'],
        reference_bl: map['reference_bl']
    );
  }

  saveUserData() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('user_id', this.id );
    sharedPreferences.setString('userName', this.userName);
    sharedPreferences.setInt('businessId',this.businessId);
    sharedPreferences.setInt('locationId',this.locationId);
    sharedPreferences.setInt('missionId',this.missionId);
    sharedPreferences.setInt('reference_bl',this.reference_bl);
  }



}
