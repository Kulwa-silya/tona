

// List<Products> productsFromJson(String str) =>
//     List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

// String productsToJson(List<Products> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Products {
//   Products({
//     required this.inventory,
//     required this.id,
//     required this.price_with_tax,
//     required this.collection,
//     required this.title,
//     required this.description,
//     required this.unit_price,
//   });

//   int id;
//   int? inventory ,price_with_tax , collection;
//   String title, description, unit_price;

//   factory Products.fromJson(Map<String, dynamic> json) => Products(
//       inventory: json["inventory"],
//       price_with_tax: json["price_with_tax"],
//       id: json["id"],
//       collection: json["collection"],
//       title: json["title"],
//       description: json["description"],
//       unit_price: json["unit_price"]
//       );

//   Map<String, dynamic> toJson() => {
//         "inventory": inventory,
//         "id": id,
//         "price_with_tax": price_with_tax,
//         "collection": collection,
//         "title": title,
//         "description": description,
//         "unit_price":unit_price
//       };
// }


// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);




// To parse this JSON data, do

    // final products = productsFromJson(jsonString);




import 'dart:convert';

List<ProductsM> productsFromJson(String str) =>
    List<ProductsM>.from(json.decode(str).map((x) => ProductsM.fromJson(x)));

String productsToJson(List<ProductsM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// ProductsM? productsFromJson(String str) => ProductsM.fromJson(json.decode(str));

// String productsToJson(ProductsM? data) => json.encode(data!.toJson());

class ProductsM {
    ProductsM({
        this.results,
    });

    List<Result?>? results;

    factory ProductsM.fromJson(Map<String, dynamic> json) => ProductsM(
        results: json["results"] == null ? [] : List<Result?>.from(json["results"]!.map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x!.toJson())),
    };
}

class Result {
    Result({
        this.id,
        this.title,
        this.description,
        this.inventory,
        this.unitPrice,
        this.priceWithTax,
        this.collection,
        this.images,
    });

    int? id;
    String? title;
    String? description;
    int? inventory;
    String? unitPrice;
    double? priceWithTax;
    int? collection;
    List<Image?>? images;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        inventory: json["inventory"],
        unitPrice: json["unit_price"],
        priceWithTax: json["price_with_tax"].toDouble(),
        collection: json["collection"],
        images: json["images"] == null ? [] : List<Image?>.from(json["images"]!.map((x) => Image.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "inventory": inventory,
        "unit_price": unitPrice,
        "price_with_tax": priceWithTax,
        "collection": collection,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x!.toJson())),
    };
}

class Image {
    Image({
        this.id,
        this.image,
    });

    int? id;
    String? image;

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}


// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

// import 'dart:convert';

// // To parse this JSON data, do
// //
// //     final products = productsFromJson(jsonString);

// List<Products> productsFromJson(String str) =>
//     List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

// String productsToJson(List<Products> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // Products? productsFromJson(String str) => Products.fromJson(json.decode(str));

// // String productsToJson(Products? data) => json.encode(data!.toJson());

// class Products {
//     Products({
//         this.count,
//         this.next,
//         this.previous,
//         this.results,
//     });

//     int? count;
//     dynamic next;
//     dynamic previous;
//     List<Result?>? results;

//     factory Products.fromJson(Map<String, dynamic> json) => Products(
//         count: json["count"],
//         next: json["next"],
//         previous: json["previous"],
//         results: json["results"] == null ? [] : List<Result?>.from(json["results"]!.map((x) => Result.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "count": count,
//         "next": next,
//         "previous": previous,
//         "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x!.toJson())),
//     };
// }

// class Result {
//     Result({
//         this.id,
//         this.title,
//         this.description,
//         this.inventory,
//         this.unitPrice,
//         this.priceWithTax,
//         this.collection,
//         this.images,
//     });

//     int? id;
//     String? title;
//     String? description;
//     int? inventory;
//     String? unitPrice;
//     double? priceWithTax;
//     int? collection;
//     List<Image?>? images;

//     factory Result.fromJson(Map<String, dynamic> json) => Result(
//         id: json["id"],
//         title: json["title"],
//         description: json["description"],
//         inventory: json["inventory"],
//         unitPrice: json["unit_price"],
//         priceWithTax: json["price_with_tax"].toDouble(),
//         collection: json["collection"],
//         images: json["images"] == null ? [] : List<Image?>.from(json["images"]!.map((x) => Image.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "inventory": inventory,
//         "unit_price": unitPrice,
//         "price_with_tax": priceWithTax,
//         "collection": collection,
//         "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x!.toJson())),
//     };
// }

// class Image {
//     Image({
//         this.id,
//         this.image,
//     });

//     int? id;
//     String? image;

//     factory Image.fromJson(Map<String, dynamic> json) => Image(
//         id: json["id"],
//         image: json["image"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//     };
// }
