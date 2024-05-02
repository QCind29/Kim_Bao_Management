import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kbstore/Model/Product.dart';
import 'package:kbstore/Provider/Product_Provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbstore/Util.dart';


class Product_Edit extends StatefulWidget {
  final bool isUpdate;
  final Product? note;
  const Product_Edit({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<Product_Edit> createState() => _ProductEditState();
}

class _ProductEditState extends State<Product_Edit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController costController = TextEditingController();

  // late String imgURL;
  FocusNode focusNode = FocusNode();

  String Title = "Tạo mới ghi chú";

  // File _imageFile = File('');
  // Uint8List nd = Uint8List(0);
  File? _imageFile1;
  String img_path="";

  bool a = false;


  @override
  void initState() {
    super.initState();
    // _initializeCamera();

    if (widget.isUpdate) {
      checkUD();
    }
    print('line 89  PD_EDit page' + _imageFile1.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Title,
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate) {
                updatePD();
              } else {
                addPD();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                        child:
                        // _imageFile.toString() == 'File: '''
                        _imageFile1 == null
                            ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(
                                10.0), // Add rounded corners
                          ),
                          width: 300,
                          height: 200,
                          child:  Center(
                            // Wrap the Column with a Center widget
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center align the children vertically
                              children: [
                                Icon(Icons.image),
                                Text('Không tìm thấy hình ảnh.')
                              ],
                            ),
                          ),
                        )
                            : Image.file(
                          _imageFile1!,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      // Expanded(flex: 1, child: Text(" ")),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            _getImage(true);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            minimumSize:
                            Size(200, 50), // Set minimum width and height
                          ),
                          // Text color
                          child: const Text('Camera'),
                        ),
                      ),
                      Expanded(flex: 1, child: Text(" ")),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            _getImage(false);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            minimumSize:
                            Size(200, 50), // Set minimum width and height
                          ), // Text color
                          child: const Text('Thư viện'),
                        ),
                      ),
                      Expanded(flex: 1, child: Text(" ")),
                    ],
                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: const Text("Tên: ",
                              textAlign:
                              TextAlign.center, // Center-align the text

                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold
                                // ),
                              ))),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: TextFormField(
                          controller: titleController,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          // decoration: const InputDecoration(
                          //   // hintText: "Tên sản phẩm",
                          // ),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: const Text("Giá: ",
                              textAlign:
                              TextAlign.center, // Center-align the text

                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold
                                // ),
                              ))),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: costController,
                        // focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        maxLines: null,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),

                        // decoration: const InputDecoration(
                        //     hintText: "Giá", border: InputBorder.none),
                      ),
                    ),
                  ],
                )),
            Container(
                height: 200,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                  BorderRadius.circular(10.0), // Add rounded corners

                  // Add border
                ),
                child: TextFormField(
                  controller: contentController,
                  // focusNode: focusNode,
                  maxLines: null,

                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

                  decoration: const InputDecoration(
                      hintText: "Mô tả", border: InputBorder.none),
                ))
          ]),
    );
  }

  Future<void> _getImage(bool camera) async {
    final imagePicker = ImagePicker();
    if (camera == false) {
      try {
        final pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            img_path = pickedFile.path;
            _imageFile1 = File(pickedFile.path);
          });
        }
      } on Exception catch (e) {
        print(e);
      }
    } else {
      try {
        final pickedFile =
        await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            img_path = pickedFile.path;

            _imageFile1 = File(pickedFile.path);
          });
        }
      } on Exception catch (e) {
        print(e);
      }
    }

  }


  Future<Uint8List> readFileAsBytes(String imgPath) async {
    Uint8List uint8List;
      if(imgPath != null && imgPath != ''){
         uint8List = await io.File(imgPath).readAsBytes();
         return uint8List;

      } else{
        print("The string path image is null");

        return Uint8List(0);
      }


  }

 updatePD() async {
  Uint8List base64String = await readFileAsBytes(img_path);
  String _img = base64Encode(base64String);

  widget.note!.Name = titleController.text;
  widget.note!.Des = contentController.text;
  widget.note!.Cost = costController.text;
  widget.note!.Img = _img;


  Provider.of<Product_Provider>(context, listen: false).updatePD(widget.note!);
  Navigator.pop(context);
}

  checkUD() async {
  File? image2;

  titleController.text = widget.note!.Name!;
  contentController.text = widget.note!.Des!;
  costController.text = widget.note!.Cost!;


  if (widget.note!.Img != Uint8List(0) && widget.note!.Img != null ) {

    image2 = await getImageFile(base64Decode(widget.note!.Img) );
    if(await image2!.exists()){
      setState(() {
        img_path = image2!.path;
        _imageFile1 = image2;
      });
    }

  }

  Title = "Chỉnh sửa sản phẩm";
  print("Line 112 Product_Edit page :" + _imageFile1.toString());
}
  addPD() async {
    Uint8List base64String = await readFileAsBytes(img_path);

    String name = titleController.text;
    String cost = costController.text;
    String des = contentController.text;
    String img = base64Encode(base64String);

    if (name != null && name.isNotEmpty && name != "" ||des != null && des.isNotEmpty && des != ""  ) {
      Product product =Product(Name: name, Cost: cost, Img: img, Des: des, Quantity:  cost);

      Provider.of<Product_Provider>(context, listen: false).addPD(product);
      print("Add new PD is completed");
    } else {
      print("Add product is failed");
    }
    Navigator.pop(context);

  }

  deletePD(){

  }
}