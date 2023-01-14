import 'dart:convert';

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    required this.inventory,
    required this.id,
    required this.price_with_tax,
    required this.collection,
    required this.title,
    required this.description,
    required this.unit_price,
  });

  int id;
  int? inventory ,price_with_tax , collection;
  String title, description, unit_price;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
      inventory: json["inventory"],
      price_with_tax: json["price_with_tax"],
      id: json["id"],
      collection: json["collection"],
      title: json["title"],
      description: json["description"],
      unit_price: json["unit_price"]
      );

  Map<String, dynamic> toJson() => {
        "inventory": inventory,
        "id": id,
        "price_with_tax": price_with_tax,
        "collection": collection,
        "title": title,
        "description": description,
        "unit_price":unit_price
      };
}