import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Controllers/productsProvider.dart';
import 'package:http/http.dart' as http;
import '../Models/getProducts.dart';

class TheSearcher extends SearchDelegate {
  ProductProvider productProvider = ProductProvider();

  bool isloading = false;
  List productList = [];

  

  fetchProducts() async {
    http.Response res = await productProvider.fetchProducts(1,"ac");

    final proddata = ProductsAll.fromJson(json.decode(res.body));
    // isloading = true;
    // productList = proddata.results;

    // isloading = false;

    print(proddata.results);

    return proddata.results;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    // InheritedBlocs.of(context)
    //     .searchBloc
    //     .searchTerm
    //     .add(query);

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        FutureBuilder(
          future: fetchProducts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data?.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data;
              return ListView.builder(
                itemCount: results?.length,
                itemBuilder: (context, index) {
                  var result = results![index];
                  return ListTile(
                    title: Text(productList[0].title),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}