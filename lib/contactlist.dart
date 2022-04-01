

// ignore: camel_case_types
class contactlist{
  String? user;
  String? phone;
  DateTime? checkin;

 
contactlist(
  
    this.user,
    this.phone,
    this.checkin
  
      
   ); 

    contactlist.fromJson(Map<String,dynamic> json)
    {
      user = json['user'];
      phone = json['phone'];
      
      checkin =  DateTime.parse(json['check-in']);

         }


    void setUsername(String x)
    {
      user=x;
    }

    String? getUsername()
    {
      return user;
    }
}


