import 'package:flutter/material.dart';
import 'package:kbstore/Model/Product.dart';
import 'package:kbstore/Service/Product_Service.dart';

class Product_Provider extends ChangeNotifier {
  Product_Service product_service = Product_Service();
  bool isLoading = true;

  List<Product> _product = [];
  List<Product> get products => _product;

  Product_Provider(){
    getAllPD();
  }



  addPD(Product pd) async {
    try {
      _product.add(pd);
      notifyListeners();
      await product_service.addProductToFirebase(
          pd.Name, pd.Des, pd.Img, pd.Cost);
    } catch (error) {
      print("Error creating product: $error");
      return -1;
    }
  }

  getAllPD() async {
    try {
      final newNote = await product_service.getPDs();
      _product = newNote;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }
  List<Product> getFilteredPD(String searchQuery) {
    return products!
        .where((element) =>
    element.Des!
        .toLowerCase()
        .contains(searchQuery.toLowerCase()) ||
        element.Name!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  updatePD(Product note1) async {
    if (products.isNotEmpty) {
      int indexofNote =
      products.indexOf(products.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        products[indexofNote] = note1;
        await product_service.updatePD(
            note1.id!, note1.Img!, note1.Name!, note1.Cost!, note1.Des!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }

  deletePD(Product note1) async {
    if (products.isNotEmpty) {
      int indexofNote =
      products.indexOf(products.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        products[indexofNote] = note1;
        await product_service.deletePD(note1.id!);
        notifyListeners();
      } else {
        print('Product not found in the list.');
      }
    } else {
      print('Products list is empty.');
    }
  }

}
