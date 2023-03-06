// import 'dart:convert';

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
//     final productsAll = productsAllFromJson(jsonString);

import 'dart:convert';

// ProductsAll productsAllFromJson(String str) => ProductsAll.fromJson(json.decode(str));

// String productsAllToJson(ProductsAll data) => json.encode(data.toJson());

// List<ProductsAll> productsAllFromJson(String str) =>
//     List<ProductsAll>.from(json.decode(str).map((x) => ProductsAll.fromJson(x)));

// String productsAllToJson(List<ProductsAll> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsAll {
    ProductsAll({
        required this.count,
        this.next,
        this.previous,
        required this.results,
    });

    int count;
    dynamic next;
    dynamic previous;
    List<Result> results;

    factory ProductsAll.fromJson(Map<String, dynamic> json) => ProductsAll(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        required this.id,
        required this.title,
        required this.description,
        required this.inventory,
        required this.unitPrice,
        required this.priceWithTax,
        required this.collection,
        required this.images,
    });

    int id;
    String title;
    String description;
    int inventory;
    String unitPrice;
    double priceWithTax;
    int collection;
    List<Image> images;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        inventory: json["inventory"],
        unitPrice: json["unit_price"],
        priceWithTax: json["price_with_tax"]?.toDouble(),
        collection: json["collection"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "inventory": inventory,
        "unit_price": unitPrice,
        "price_with_tax": priceWithTax,
        "collection": collection,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
}

class Image {
    Image({
        required this.id,
        required this.image,
    });

    int id;
    String image;

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}