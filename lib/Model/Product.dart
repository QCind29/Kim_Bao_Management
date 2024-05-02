


import 'dart:convert';
import 'dart:typed_data';

List<Product> ProductFromJson(String str) => List<Product>.from(json.decode(str).map((x)=>Product.fromJson(x)));

String ProductToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));




class Product {
  String? id;
  String Name;
  String Des;
  String Cost;
  String Img;
  String Quantity;
  bool isExpanded;



  Product({
    this.id,
    required this.Name,
    required this.Cost,
    required this.Img,
    required this.Des,
    required this.Quantity,
    this.isExpanded = false,


  });


  Product.fromMap(Map<String, dynamic>res):
        id = res['id'],
        Name = res['Name'] ?? "",
        Cost = res['Cost']??"",
        Img=res['Img']?? "",
        Quantity=res['Quantity']?? "",
        isExpanded = res['isExpanded'],

        Des = res['Des']??"";


  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "Name" : Name,
      "Cost" : Cost,
      "Img" : Img,
      "Des": Des,
      "Quantity": Quantity,
      "isExpanded": isExpanded


    };
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      Name: json["Name"],
      Cost: json["Cost"],
      Img: json["Img"],
      Des: json["Des"],
    Quantity: json["Quantity"],
      isExpanded: json["isExpanded"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Name": Name,
    "Cost": Cost,
    "Des": Des,
    "Img": Img,
    "isExpanded": isExpanded,
    "Quantity": Quantity,

  };
  @override
  String toString() {
    return 'Product(Name: $Name, Quantity: $Quantity, id: $id, Cost: $Cost, Img: $Img, Des: $Des,'
        ' isExpanded: $isExpanded)';
  }
}

