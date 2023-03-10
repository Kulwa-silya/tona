import 'dart:convert';

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
    List<Imagez> images;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        inventory: json["inventory"],
        unitPrice: json["unit_price"],
        priceWithTax: json["price_with_tax"]?.toDouble(),
        collection: json["collection"],
        images: List<Imagez>.from(json["images"].map((x) => Imagez.fromJson(x))),
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

class Imagez {
    Imagez({
        required this.id,
        required this.image,
    });

    int id;
    String image;

    factory Imagez.fromJson(Map<String, dynamic> json) => Imagez(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}