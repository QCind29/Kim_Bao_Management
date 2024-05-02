import 'package:firebase_database/firebase_database.dart';
import 'package:kbstore/Model/Product.dart';

class Product_Service {

  Future<void> addProductToFirebase(String Name, String Des, String Img, String Cost) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('product');

    String? noteId = databaseReference.push().key;

    // Create a new Task object
    Product product =
        Product(id: noteId, Des: Des, Name: Name, Cost: Cost, Img: Img, Quantity:Cost );

    // Serialize the Task object to Map
    Map<String, dynamic> productMap = product.toMap();

    // Add data to Firebase
    await databaseReference
        .child('productId')
        .push()
        .set(productMap)
        .then((value) {
      print('Product added successfully.');
    }).catchError((error) {
      print('Failed to add product: $error');
    });
  }

  Future<List<Product>> getPDs() async {
    // Get a reference to the 'task' node in Firebase Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref().child('product');

    try {
      // Fetch data from the database as a DataSnapshot
      final DatabaseEvent databaseEvent = await databaseReference.once();
      final DataSnapshot dataSnapshot = databaseEvent.snapshot;

      // Check if data exists
      if (dataSnapshot.exists) {
        // Cast the snapshot value to a dynamic map if necessary
        final Map<Object?, Object?> noteData =
            dataSnapshot.value as Map<Object?, Object?>;

        if (noteData != null) {
          final List<Product> notes = [];

          // Iterate through each child node (task) in the snapshot
          for (final childSnapshot in dataSnapshot.children) {
            // Cast the child's value to a dynamic map

            final Map<Object?, Object?> childData =
                childSnapshot.value as Map<Object?, Object?>;
            // print("Line 183 Task_Service + " +childData.toString());
            // Convert _Map<Object?, Object?> to Map<dynamic, Map<dynamic, dynamic>>
            final Map<dynamic, Map<dynamic, dynamic>> childData1 =
                childData.map((key, value) {
              return MapEntry(key, value as Map<dynamic, dynamic>);
            });
            childData1.forEach((key, innerMap) {
              Map<dynamic, dynamic>? innerMap = childData1[key];
              if (childData != null) {
                final Product note = Product(
                  id: key.toString(),
                  Name: innerMap?['Name']?.toString() ?? "",
                  Des: innerMap?['Des']?.toString() ?? "",
                  Cost: innerMap?['Cost']?.toString() ?? "",
                  Img: innerMap?['Img']?.toString() ?? '',
                  Quantity: innerMap?['Quantity']?.toString() ??''
                );

                notes.add(note);
                // notes.sort((a, b) => DateTime.parse(a.DateCreate)
                //     .compareTo(DateTime.parse(b.DateCreate)));
              }
            });
          }

          return notes;
        } else {
          print('List Product is null');
          return [];
        }
      } else {
        print('No product found in the database');
        return [];
      }
    } on Exception catch (e) {
      print('Error fetching product: $e');
      return [];
    }
  }

  Future<void> updatePD(
      String id, String? img, String? name, String? cost, String? content) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('product');
    // String? a = DateTime.now().toString(); // Reference to the child node
    try {
      if (name != null && cost != null ) {
        await databaseReference.child('productId/$id').update({
          'Des': content,
          'Name': name,
          'Img': img,
          'Cost': cost
        });
        print('Product content updated successfully.');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deletePD(String id) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('product');

    try {
      await databaseReference.child('productId/$id').remove();
      print('Note delete successfully.');
    } on Exception catch (e) {
      print(e);
    }
  }
}
