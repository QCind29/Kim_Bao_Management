import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:kbstore/Service/Auth_Service.dart';
import 'package:kbstore/Util.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kbstore/Model/Product.dart';
import 'package:kbstore/Page/Product/Product_Edit_Page.dart';
import 'package:kbstore/Provider/Product_Provider.dart';
import 'package:kbstore/Widget/CustomAlertDialog.dart';
import 'package:kbstore/Widget/CustomAppBar.dart';
import 'package:kbstore/Widget/EmptyUI.dart';
import 'package:kbstore/Widget/LoadingUI.dart';
import 'package:kbstore/Widget/Notification.dart';
import 'package:provider/provider.dart';

class Product_Page extends StatefulWidget {
  const Product_Page({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _Product_PageState createState() => _Product_PageState();
}

class _Product_PageState extends State<Product_Page> {
  Product_Provider _product_provider = Product_Provider();
  List<Product> pds = [];
  String searchQuery = "";
  final AuthService _authService = AuthService();

  refresh() async {
    final provider = Provider.of<Product_Provider>(context, listen: false);
    // setState(() {
    await provider.getAllPD();
    // });
    // print("line 26 Task_page: " + _tasks[1].Done.toString());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    setState(() {
      refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Product_Provider pdProvider = Provider.of<Product_Provider>(context);
    List<Product> SListNote = pdProvider.getFilteredPD(searchQuery);
    // List<Product> LListNote = pdProvider.getAllPD();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Sản phẩm",
        actions: [
          IconButton(
            onPressed: () async {
              bool isLoggedIn = await _authService.isUserLoggedIn();
              if (isLoggedIn) {
                // print("Line 71 Product_Page đã đăng nhập");
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>
                                Product_Edit(note: null, isUpdate: false)))
                    .then((value) => refresh());
              } else {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    content: "Bạn cần đăng nhập để thực hiện chức năng này",
                  ),
                );
                // print("Line 80 Product_Page chưa đăng nhập");
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: (_product_provider.isLoading == false)
          ? SafeArea(
              child: (_product_provider.products!.length > 0)
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(hintText: "Search"),
                          ),
                        ),
                        (_product_provider.getFilteredPD(searchQuery).length >
                                0)
                            ? Expanded(
                                // padding: const EdgeInsets.all(8.0),
                                child:
                                    // _buildPanel(SListNote),
                                    // ListPDUI(SListNote),
                                    ListPDUI2(SListNote),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "No notes found!",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    )
                  : EmptyUI(
                      content: "Danh sách ghi chú đang rỗng",
                    ))
          : LoadingUI(),
    );
  }

  Widget ListPDUI2(List<Product>? a) {
    // print(a);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ExpansionPanelList(
            expansionCallback: (int indexx, bool isExpanded) {
              setState(() {
                a?[indexx].isExpanded = isExpanded;
              });
            },
            children: a!.map<ExpansionPanel>((Product item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      // height: 200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // Set the clip behavior of the card
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: item!.Img.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(item.Img),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image_not_supported_outlined)),
                          Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      item.Name,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                      title: Text(
                                    menhgia(int.parse(item.Cost)).toString() +
                                        "đ",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ))
                                ],
                              ))
                        ]),
                      ),
                    ),
                  );
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Aligns children at the start (left side)

                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.all(10), child: Text(item.Des)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, // Aligns children at the end of the row (right side)
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            bool isLoggedIn =
                                await _authService.isUserLoggedIn();
                            if (isLoggedIn) {
                              setState(() {
                                _showAlertDialog(context, item);
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  content:
                                      "Bạn cần đăng nhập để thực hiện chức năng này",
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () async {
                            bool isLoggedIn =
                                await _authService.isUserLoggedIn();
                            if (isLoggedIn) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => Product_Edit(
                                            note: item,
                                            isUpdate: true,
                                          )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  content:
                                      "Bạn cần đăng nhập để thực hiện chức năng này",
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context, Product note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa'),
          content: Text('Có muốn xóa?'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Padding around the button content
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () async {
                  await deleteNote(note);
                  showDeletionNotification(context, "Xóa thành công");
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text("Xóa "), Icon(Icons.delete)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  deleteNote(Product note) async {
    await _product_provider.deletePD(note);
    refresh();
  }
}
